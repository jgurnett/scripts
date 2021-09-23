#!/usr/bin/env python3
#  Joel Gurnett
#  alerts me when servers are down
#  September 18, 2021
import os
import subprocess

servers = {
    'minecraft': '192.168.1.**',
    'owncloud': '192.168.1.**',
    'vpn': '192.168.1.**',
}

fileName = "<path to log file>"


def emailAlreadySent(ip):
    with open(fileName, "r") as file:
        if ip in file.read():
            return True
        return False


def addToList(ip):
    f = open(fileName, "a")
    f.write('{}\n'.format(ip))
    f.close()


def removeFromList(ip):
    with open(fileName, "r") as f:
        lines = f.readlines()
    with open(fileName, "w") as f:
        for line in lines:
            if line.strip("\n") != ip:
                f.write(line)


def createEmail(hostname):
    message = """To: joel@joelgur.net
From: "Servers" <servers@joelgur.net>
Subject: Server Alert
MIME-Version: 1.0
Content-Type: text/plain

server {} is down
""".format(hostname)
    file = open("email", "w+")
    file.write(message)
    file.close()


def sendEmail(hostname):
    try:
        createEmail(hostname)
        addToList(servers[hostname])
        bashCmd = 'cat email'
        ps = subprocess.Popen(bashCmd.split(), stdout=subprocess.PIPE)
        output = subprocess.check_output(('sendmail', '-i', '-t'),
                                         stdin=ps.stdout)
        ps.wait()
        print("\n", output, "\n")
        os.remove("email")
    except Exception as error:
        print("Error: unable to send email", error)


def pingServer(hostname):
    response = os.system("ping -c 1 " + servers[hostname])
    if response != 0 and not emailAlreadySent(servers[hostname]):
        sendEmail(hostname)
    elif (response == 0 and emailAlreadySent(servers[hostname])):
        removeFromList(servers[hostname])


def main():
    for server in servers:
        pingServer(server)


main()