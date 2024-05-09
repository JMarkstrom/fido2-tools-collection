######################################################################
# YubiKey (FIDO) PIN generator                   
######################################################################
# version: 1.0
# last updated on: 2024-05-09 by Jonas Markström (swjm.blog)
# see readme.md for more info.
#
# DEPENDENCIES: 
#   - YubiKey Manager (ykman) CLI must be installed on the system
#   - Python-fido2 must be installed on the system 
#
# LIMITATIONS/ KNOWN ISSUES: N/A
# 
# USAGE: python yubikey-pin-gen.py
#
# BSD 2-Clause License                                                             
# Copyright (c) 2024, Jonas Markström
#
#   Redistribution and use in source and binary forms, with or
#   without modification, are permitted provided that the following
#   conditions are met:
#
#    1. Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#    2. Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
######################################################################

# Standard Library Imports
import json
import secrets
import sys
import time
from threading import Timer
import platform
from time import sleep

# Third-Party Library Imports
import click
from contextlib import contextmanager
from fido2.ctap2 import Ctap2, ClientPin, Config
from fido2.ctap2.pin import ClientPin
from fido2.hid import CtapHidDevice
import string

# Local Imports
from ykman import scripting as s
from ykman.device import list_ctap_devices
from yubikit.core.fido import FidoConnection
from yubikit.management import ManagementSession


# Set variable to control PIN length
"""
Change this value to '6' if you must...
"""
pin_length = 4


# Function to display program banner
def banner():
    """
    Displays an ASCII art banner to the console.
    """
    click.clear()
    click.clear()
    click.secho(" Welcome to:                                              ", fg='green',bold=True)
    click.secho("__  __      __    _ __ __               ____  _____   __  ", fg='green',bold=True)
    click.secho("\ \/ /_  __/ /_  (_) //_/__  __  __    / __ \/  _/ | / /  ", fg='green',bold=True)
    click.secho(" \  / / / / __ \/ / ,< / _ \/ / / /   / /_/ // //  |/ /   ", fg='green',bold=True)
    click.secho(" / / /_/ / /_/ / / /| /  __/ /_/ /   / ____// // /|  /    ", fg='green',bold=True)
    click.secho("/_/\__,_/_.___/_/_/ |_\___/\__, /   /_/   /___/_/ |_/     ", fg='green',bold=True)
    click.secho("   ____ ____  ____  ___  _/____/__ _/ /_____  _____       ", fg='green',bold=True)
    click.secho("  / __ `/ _ \/ __ \/ _ \/ ___/ __ `/ __/ __ \/ ___/ 1.0   ", fg='green',bold=True)
    click.secho(" / /_/ /  __/ / / /  __/ /  / /_/ / /_/ /_/ / /           ", fg='green',bold=True)
    click.secho(" \__, /\___/_/ /_/\___/_/   \__,_/\__/\____/_/            ", fg='green',bold=True)     
    click.secho("/____/                                                    ", fg='green',bold=True)
    click.secho("                                                          ")


# Check if program is running as administrator
"""
Checks if the script is running with administrative privileges (required on Windows).
"""
if platform.system() == "Windows":
    import ctypes

    if ctypes.windll.shell32.IsUserAnAdmin() != 0:
        pass
    else:
        click.clear()
        banner()
        click.pause(
            "Program is not running as administrator (press any key to exit)"
        )
        click.clear()
        # Exit program in 3 seconds
        for i in range(3, 0, -1):  # Countdown from 3 seconds
            click.secho(f"Exiting program in {i} seconds...")
            time.sleep(1)
            click.clear()
        click.clear()
        sys.exit(1)
else:
    pass


# Check for output file
# TODO: Append (and handle duplicates) file
"""
Programmed YubiKeys will be written to an output file.
"""
# Initialize output data as an empty list
data = []
# Create the output file
with open("output.json", "w") as jsonfile:
    json.dump(data, jsonfile)


# Function that runs the entire YubiKey programming sequence
def yubikey_pin_generator():

    # Function to write configuration of YubiKey to file
    def write_json():
        """
        Writes programmed YubiKey information to a JSON file.
        The modified data is written to the 'output.json' file.
        """
        new_data = []
        # Add programmed YubiKey information to JSON data
        new_data.append(
            {
                "Model": device.name,
                "Serial number": serial_number,
                "PIN": pin,
                "PIN change required": pin_change,
            }
        )
        data.append(new_data)

        # Write the modified data back to the JSON file
        with open("output.json", "w") as jsonfile:
            json.dump(data, jsonfile, indent=4)


    # Function to prompt user for touching the YubiKey
    def prompt_for_touch():
        """
        Prompts the user to touch the inserted YubiKey.

        Clears the screen and displays a message instructing the user to touch the YubiKey.

        Raises:
            OSError: If clearing the screen fails.

        Example:
            prompt_for_touch() OR prompt_timeout()
        """
        try:
            banner()
            click.echo("Touch YubiKey...", err=True)
        except Exception:
            sys.stderr.write("Touch YubiKey...")


    # Function for touch timeout during prompt
    @contextmanager
    def prompt_timeout(timeout=0.5):
        """
        Context manager providing a timeout for a prompt (touch) operation.

        Sets a timeout for a prompt operation. If the operation exceeds the specified
        timeout, it is automatically canceled. Timeout duration is in seconds.

        Args:
            timeout (float, optional): Duration of the timeout in seconds. Default is 0.5 seconds.

        Example: prompt_timeout()

        """
        timer = Timer(timeout, prompt_for_touch)
        try:
            timer.start()
            yield None
        finally:
            timer.cancel()


    # Function to handle removal and reinsertion of YubiKey
    def prompt_re_insert():
        """
        Continuously checks for the re-insertion of a YubiKey after it has been removed.

        This function monitors the connected FIDO devices by calling the list_ctap_devices()
        function periodically. If a device is removed, it waits for it to be re-inserted.

        Returns:
            Union[FidoConnection, None]: An instance of FidoConnection representing the
            re-inserted FIDO device if found, or None if no device is re-inserted.
        """

        removed = False
        while True:
            sleep(0.5)
            keys = list_ctap_devices()
            if not keys:
                removed = True
            if removed and len(keys) == 1:
                return keys[0].open_connection(FidoConnection)
            

    # Function to reset the FIDO application of a YubiKey
    def reset_yubikey():
        """
        Resets the FIDO application (U2F and FIDO2) of a YubiKey.

        This function guides the user through the process of resetting the FIDO application on a YubiKey.
        It displays a warning and then performs the reset if the YubiKey matches the expected serial number.

        Args:
            None
        Raises:
            SystemExit: If no YubiKey is re-inserted, the function exits with a status code of 1.
        """
        banner()
        # Warn user of FIDO2 application reset
        if click.confirm(
            "YubiKey will be reset. Do you want to continue?", default=True
        ):
            click.clear()
        else:
            # Exit program in 3 seconds
            for i in range(3, 0, -1):  # Countdown from 3 seconds
                banner()
                click.secho(f"Exiting program in {i} seconds...")
                time.sleep(1)
                click.clear()
                click.clear()
            sys.exit(1)

        # Now reset the YubiKey FIDO application
        banner()
        click.echo("Remove and re-insert YubiKey...")

        connection = prompt_re_insert()

        # Read serial number of (re)inserted YubiKey to perform comparison
        reinserted_device = ManagementSession(connection).read_device_info().serial

        if reinserted_device:
            if reinserted_device == serial_number:
                with prompt_timeout():
                    Ctap2(connection).reset()
                banner()
                click.secho("Reset successful.")
                time.sleep(1)
            else:
                reinserted_device != serial_number
                banner()
                click.echo(f"Expected YubiKey with serial number {serial_number}.")
                click.pause()
                # Call reset_yubikey again to restart the process if the serial number is incorrect
                reset_yubikey()
        else:
            banner()
            click.echo("No YubiKey re-inserted. Exiting...")
            sys.exit(1)
        click.clear()


    # Function to hold dictionary of blacklisted FIDO2 PIN codes
    """
    This list contains disallowed PINs as per Yubico's 2024 PIN complexity rules. For more information: 
    https://docs.yubico.com/hardware/yubikey/yk-tech-manual/5.7-firmware-specifics.html#pin-complexity
    
    NOTE: This script currently does not enforce PIN complexity or PIN length. Instead it makes sure the 
    random PIN generated complies with these settings, if set prior. Note also that if PIN length is '4'
    then the check against the list of disallowed PINs is "less" relevant. Lastly, since we are generating
    numerical PINs it is not necessary to disallow alphanumerical PINs (see URL).
    """
    disallowed_pins = [
        "123456",
        "123123",
        "654321",
        "123321",
        "112233",
        "121212",
        "520520",
        "123654",
        "159753",
        
    ] # Add more as you see fit!


    # Function to generate random FIDO2 PIN codes
    def generate_random_pin():
        """
        Generates a random numerical PIN.

        This function utilizes the secrets module to securely generate a random PIN.
        The PIN consists of numerical digits (0-9) and does not contain any letters or special characters.
        Trivial PINs (e.g., all digits are the same) and PINs in the banned list are disallowed.

        Returns:
            str: A string representing the generated PIN.
        """
        while True:
            digits = "".join(
                secrets.choice(string.digits) for _ in range(pin_length)
            )
            # Check if PIN is not trivial and not in banned list
            if len(set(digits)) != 1 and digits not in disallowed_pins:
                return digits
            

    # Function to set PIN on the YubiKey
    def set_fido_pin(pin):
        """
        Set the FIDO2 PIN on the inserted YubiKey.

        If a PIN is already set, the function will first reset the FIDO2 applet before setting a new PIN.
        If no PIN is set, it will directly set a new PIN.

        Args:
            pin (str): The desired PIN to be set on the YubiKey.

        Raises:
            Exception: If there is an error while setting the PIN or resetting the FIDO2 applet.
        """

        devices = list(CtapHidDevice.list_devices())
        ctap = Ctap2(devices[0])

        # Determine PIN status of inserted YubiKey
        if ctap.info.options.get("clientPin"):

            # Call reset of the FIDO2 applet if PIN is already set
            reset_yubikey()
            # Reconnect to YubiKey
            devices = list(CtapHidDevice.list_devices())
            ctap = Ctap2(devices[0])
            # Set a random PIN
            client_pin = ClientPin(ctap)
            client_pin.set_pin(pin)

        else:
            # Reconnect to YubiKey
            devices = list(CtapHidDevice.list_devices())
            ctap = Ctap2(devices[0])
            # Set a random PIN
            client_pin = ClientPin(ctap)
            client_pin.set_pin(pin)


    # Function to read the YubiKey serial number
    def read_serial_number():
        device = s.single()
        serial_number = device.info.serial
        return serial_number


    # Function to check if the serial number is already in the JSON file
    def is_serial_number_in_file(serial_number):
        """
        Check if a serial number is present in the 'output.json' file.

        This function helps avoid programming errors where a user attempts to program a YubiKey that has
        already been programmed. It searches the 'output.json' file for the provided serial number and
        returns True if the serial number is found, False otherwise.

        Args:
            serial_number (str): The serial number to search for in the 'output.json' file.

        Returns:
            bool: True if the serial number is found in the file, False otherwise.
        """
        try:
            with open("output.json", "r") as jsonfile:
                data = json.load(jsonfile)
                for entry in data:
                    for item in entry:
                        if item.get("Serial number") == serial_number:
                            return True
        except FileNotFoundError:
            return False
        return False


    # Loop to continuously check for YubiKey
    while True:
        banner()
        serial_number = read_serial_number()
        if is_serial_number_in_file(serial_number):
            # If the serial number exists in the output.json file, inform the user
            banner()
            click.pause(
                "Insert a new YubiKey and press any key to continue..."
            )
        else:
            # If the serial number does not exist, break the loop
            break
        time.sleep(1)  # Add a short delay to prevent the loop from consuming too much CPU


    # Read the YubiKey serial number (again)
    serial_number = read_serial_number()


    # Generate a random PIN
    pin = generate_random_pin()


    # Now set the PIN on the YubiKey
    set_fido_pin(pin)


    """
    NOTE: The ability to force change of the YubiKey PIN was introduced in CTAP 2.1.
    This means that if CTAP 2.1 is supported by BOTH (note!) the YubiKey AND the client
    then we can force a change of PIN on first use. Note however, that if CTAP 2.1
    IS NOT supported by the client but IS supported by the YubiKey then the YubiKey
    CANNOT be used (on that client). 

    As of May 2024 the capability is supported on:

        * YubiKey BIO (any)
        * YubiKeys (any) with FW 5.7 and later
        * Windows 11
        * Google Chrome
    """
    banner()
    if click.confirm("Force user to change PIN on first use?", default=True):

        device = s.single()
        with device.fido() as connection:
            ctap = Ctap2(connection)
            if ctap.info.options.get("setMinPINLength"):
                client_pin = ClientPin(ctap)
                token = client_pin.get_pin_token(
                    pin, ClientPin.PERMISSION.AUTHENTICATOR_CFG
                )
                config = Config(ctap, client_pin.protocol, token)
                config.set_min_pin_length(force_change_pin=True)

                # Since the user requested AND the YubiKey supports forced PIN change we set a 'true' flag
                pin_change = True
                banner()
                click.pause(
                    "PIN set to expire on first use (press any key to continue...)"
                )

            else:
                # Since YubiKey does not support forced PIN change we set a 'false' flag
                pin_change = False
                banner()
                click.pause(
                    "YubiKey does not support capability (press any key to continue...)"
                )

    else:
        # Since the user does not want to have forced PIN change we set a 'false' flag
        device = s.single()
        pin_change = False


    # Write JSON output file containing relevant attributes
    write_json()


def main():
    while True:
        # Program a YubiKey
        yubikey_pin_generator()

        # Ask the user if they want to program another YubiKey
        banner()
        if not click.confirm("Do you want to configure another YubiKey?", default=False):
            # Exit program in 3 seconds
            for i in range(3, 0, -1):  # Countdown from 3 seconds
                banner()
                click.secho(f"Exiting program in {i} seconds...")
                time.sleep(1)
                click.clear()
            click.clear()
            sys.exit(1)


# Run script
if __name__ == "__main__":
    main()
