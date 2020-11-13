# Clam Scan
Script I use to scan my servers for viruses
<br />
[Documentation](https://www.clamav.net/documents/clam-antivirus-user-manual)

## clamAV-Script.sh
### Usage
* `chmod +x clamAV-Script.sh`
* `./clamAV-Script.sh`
* I run ClamScan with the below crontab to run everyday at 1am <br />
`0 1 * * * /home/clamAV/clamAV-Script.sh`
