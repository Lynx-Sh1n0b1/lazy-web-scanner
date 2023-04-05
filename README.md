# lazy-web-scanner
This script automates the process of scanning a target host or IP address for open ports and services, performing various scans to identify vulnerabilities and potential attack vectors.
The script uses a variety of tools such as Nmap, Nikto, Sslyze, and Dirb to scan the target host and identify any potential vulnerabilities or weaknesses in the target's security. The output of each scan is saved in a folder named after the target host, with a timestamp appended to the folder name.
The script is designed to be easy to use, with all prompts and inputs explained in detail during the scanning process. Additionally, the script is designed to work in silent mode, with all output saved to files and not displayed on the terminal, making it easy to run in the background.
The logic of the script is:

	1	Asking the user to input the target IP or URL to scan.
	2	Bash echo statements to providing feedback to the user throughout the scanning process.
	3	Pinging the target to check if it's alive. If it's not alive, use nmap to scan the target without ping (-Pn) and save the output to a file in the created folder.
	4	If the target is alive, proceed to use nmap to scanning for open ports and services with version detection (-sV) and save the output to a file in the created folder.
	5	If any open web ports are found (i.e. ports 80 or 443), starting a Nikto scan and save the output to a file in the created folder.
	6	For each open web port, start a directory bruteforce with dirb scanning and save the output to a file in the created folder.
	7	If port 443 is open, performing an SSLyze scan to find any problems with certificates and save the output to a file in the created folder.
	8	Performing a nmap script scan with all script groups enabled except for brute-force and intrusive scripts and saving the output to a file in the created folder.
	9	Displaying a funny banner :) 
	10	Printing a message indicating the location of the folder where all the scan results are saved.
	11	Saying goodbye.
	12	Don't forget chmod +x it!  
