#!/bin/bash
# Maarten Miers - Bengt Verscheure - TI2 groep2
# System Engineering 3 --- Mondeling Examen (BACKUP  SCRIPT)

# Default Configuration file
CFG_FILE="/home/tijn/gitProjects/dirs.txt"

# Checks if script is running as root
if [ "$(whoami)" != 'root' ]
then
	echo "Run $0 as root!"
	exit 1
fi

# Define the host
HOST_NAME=$(hostname -s)

# Define date variables
DATE=`date --rfc-3339=date`
TIME=`date +time%Hh%Mm%S`
BACKUP_FILE="$TIME-$HOST_NAME-backup.tar"

# Default backup directory
#BACKUP_DIR="/home/tijn/gitProjects/backupTest/" # change to /archief, also add check to see if "/archief" exists
#BACKUP_DIR="/home/tijn/gitProjects/backupTest/$DATE-backup"
BACKUP_DIR="/archief/$DATE-backup"

if [ ! -d "$BACKUP_DIR" ]
then
	echo -e "Creating backup directory: $BACKUP_DIR ...\n"
        mkdir -p $BACKUP_DIR
fi

# set flags
DEFAULT_CFG=true
ABSOLUTE_PATH=true
GZIP=false

function helpFct() {
	clear
	echo "BACKUPSCRIPT"
	echo "	This script makes backups of certain directories/files specified in a config folder."
	echo "	A custom config folder can be set by using: -cc"
	echo "	The default archive locations is /archief"
	echo "	Run this script as ROOT!"
	echo ""
	echo "USAGE example:"
	echo "	$0 -b"
	echo "	$0 -cc /path/to/config"
	echo ""
	echo "OPTIONS"
	echo "	-h, --help"
	echo "	Shows the help function"
	echo ""
	echo "	-b, --backup"
	echo "	This parameter runs the backup script with default settings."
	echo ""
	echo "	-cc, --custcfg"
	echo "	Backup files specified in a non-default cfg file."
	echo ""
	echo "	-g, --gzip"
	echo "	Zips the tarfile."
	echo ""
	echo "	-r, --relative"
	echo "	Makes your backup relative."
	echo "	Extracting the tarfile will only give you relative files and folders."
	echo ""
	exit 0
}

# Check if the files/directories exist and load them up into the BACKUP_LIST
function checkForValidity() {
	# If found directory or file.
	if [ -d "$backupLine" ] || [ -f "$backupLine" ]	
	then
		# Places valid file and directory locations into a list.
		BACKUP_LIST="$BACKUP_LIST $backupLine"
	else
		echo "$backupLine is not a valid file or directory!"
		echo ""
	fi
}

# This while loop splits each new line into a segment
function separateFileFct() {
	# Sees if the default cfg file is set or not
	if [ $DEFAULT_CFG = false ]
	then
		CFG_FILE=$1
	fi
	# Sees if CFG_FILE exists
	if [ ! -f $CFG_FILE ]
	then
		echo "The config file: $CFG_FILE does not exist!"
		exit 1
	fi
	
	# while splitting on newlines, read "userline"
	while SEPARATOR="\n" read backupLine;
	do
		checkForValidity
	done < <(grep '' $CFG_FILE) # read the content of the textfile
	# grep is used here to avoid the last user from being skipped.
	# source: http://stackoverflow.com/questions/16627578/bash-iterating-through-txt-file-lines-cant-read-last-line	
}

# loops and checks if parameter is present
if [ -z "$1" ]
then
	echo "Wrong parameter! Please use the help function '$0 -h'"
	exit 1
else
	until [ -z $1 ]
	do
		case $1 in
			-h | --help	)
				helpFct
				;;
			
			-b | --backup	)
				DEFAULT_CFG=true
				separateFileFct 
				;;
			
			-cc | --custcfg	)
				shift
				DEFAULT_CFG=false
				separateFileFct $1
				;;

			-r | --relative	) # Makes the backup relative (no absolute paths when extracted)
				ABSOLUTE_PATH=false
				;;

			-g | --gzip	)
				GZIP=true
				;;

			*		)
				helpFct
				;;
		esac
	    shift
	done
fi

# counts list items
COUNT_LIST=$(echo ${BACKUP_LIST[@]} | wc -w) 

# If no files or dirs from the cfg-file are valid, exit!
if [ $COUNT_LIST -eq 0 ]
then	
	echo "None of the files or directories from the cfg-file were valid!"
	exit 1
fi


echo -e "\nBacking up the next files and directories from:\n$CFG_FILE\n"

TAR_FILE="$BACKUP_DIR/$BACKUP_FILE"

# create empty tar file (we will append files to this)
tar -cf $TAR_FILE  --files-from /dev/null

# Loop through the BACKUP_LIST
for dirfile in ${BACKUP_LIST[@]} # dirfile is a directory or a file
do
	if [ -d "$dirfile" ] # if true, then the listitem must be a directory
	then
		if [ $ABSOLUTE_PATH = true ]
		then
			echo "Backing up the: $dirfile directory ..."
			tar -rpPf $TAR_FILE $dirfile # -P removes the "removing leading /" error
			# -p leaves the permissions preserved
		else
			echo "Backing up the: $dirfile directory ..."
			# maybe use pushd and popd?
			subDir=`basename $dirfile` # basename strips the parent paths off a directory 
			cd $dirfile/.. # please don't use this method in a professional context
			tar -rpf $TAR_FILE $subDir # -r append  to the previously created tarfile
		fi
		echo ""
	else # The listitem must be a file
		if [ $ABSOLUTE_PATH = true ]
		then
			echo "Backing up the: $dirfile file ..."
			tar -rpPf $TAR_FILE $dirfile 
		else	
			echo "Backing up the: $dirfile file ..."
			subFile=`basename $dirfile`
			parDir=`dirname $dirfile`
			tar -rpf $TAR_FILE -C $parDir $subFile # -C to go to a certain directory 
		fi
		echo ""
	fi
done

if [ $GZIP = true ]
then
	echo -e "\nG-Zipping the tarfile.. \n$TAR_FILE.gz"	
	gzip $TAR_FILE
fi

echo -e "\n\nYour backup can be found in:\n$BACKUP_DIR\n"	
echo -e "$COUNT_LIST separate files and directories were backed up\n"
ls -lh $BACKUP_DIR

# tar rf file.tar bla.txt	append bla.txt to file.tar
# tar tf file.tar		to show content
# tar xf file.tar		to extract tarcontent
# tar zxf file.tar		to unzip tar.gz
# gzip -d 			to unzip
# tar p 			preserve permissions

# more sources used:

# https://help.ubuntu.com/lts/serverguide/backup-shellscripts.html

# http://stackoverflow.com/questions/18458839/how-to-get-the-current-date-and-time-in-the-terminal-and-set-a-custom-command-in

# http://www.karkomaonline.com/index.php/2005/03/basic-tar-usage-gnu-tar/

# http://unix.stackexchange.com/questions/59243/tar-removing-leading-from-member-names/59244

# http://stackoverflow.com/questions/3294072/bash-get-last-dirname-filename-in-a-file-path-argument

# http://archive.oreilly.com/linux/cmd/cmd.csp?path=t/tar

# 