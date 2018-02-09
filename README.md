# iphoto-dirtree-to-flat-tree
A bash script to convert the directory tree and image files created by iphoto in to a flat single directory. This is useful for people who no longer use iphotos, and want to more easily view their old photos on a Linux computer. It copies the old files in to flattened version of the directory tree structure created by iphotos. It gives each file a unique name based on it's location in the original directory structure. 


## Example 
If the input source directory contains directories and files like this:  
`./pictures/iPhoto Library.photolibrary/Masters/2014/11/23/1234/birthday.mov,
./pictures/iPhoto Library.photolibrary/Masters/2016/03/16/1234/barbecue.jpg,
./pictures/iPhoto Library.photolibrary/Masters/2017/09/03/1234/beach.png`  


This script will output the following in to the destination directory:  
`2014-11-23-1234-birthday.mov,
2016-03-16-1234-barbecue.jpg,
2017-09-03-1234-beach.png`


## Test Mode
`./convert_files.sh` by default (Meaning no source or destination directory arguments given) is run in **test mode**. Test mode will create a 'Masters/' directory and a 'converted_files/' directory in the current working directory. 'Masters/' will contain 4 folders, with 5 jpgs located in the end/bottom directory of each. Test will then copy/rename the 20 files over in to 'converted_files/'.

I recommend you try out the test mode first, to make sure it works the way that you want it to.


## Instructions
1) Clone the repository locally to your machine.
   - Open up terminal
   - Go to desired directory e.g. `cd ~\myNewDirectory`
   - Enter in `git clone https://github.com/ryanpaixao/iphoto-dirtree-to-flat-tree`
   
2) Go into newly cloned repository's directory
   - Enter in  `cd ./iphoto-dirtree-to-flat-tree`
   
3) Run the convert_files.sh script in the default test mode
   - Enter in `./convert_files.sh`   
     - A prompt will appear asking if you want to run it in **test mode**.
   - Enter in `y`
   
4) Check that the test mode created the source directory 'Masters/' and the destination directory 'converted_files/'
   - Use `ls` to see that both directories are present
   - Enter in `cd ./Masters` to check 'Masters/' directory contains 4 directories
   - Enter in `cd ../converted_files`, and see that there are 20 files present (created from 4 different folders containing 5 files)
   - Return to the parent directory by entering in `cd ..`

5) Once you have check that test worked sucessfully, run the convert_files.sh script. Make sure to supply it with the source directory location and the destination directory location.
   - The source directory should not be a sub-directory of iphoto's 'Masters/' directory. For this to work you have to specifiy the exact location of 'Masters/'.
   - e.g. If source is './my/old/source/directory/Masters' and the destination is './my/new/destination/directory' then you would use the command: `./convert_files.sh ./my/old/source/directory ./my/new/destination/directory`

6) Check your destination directory. All you files should be there, copied over, and renamed!!

## Change Log
##### v1.0.0
- initial version

## Troubleshooting
1) If you attempt to run `./convert_files.sh` and you get an error message saying "Permission denied", do the following:
   - enter in `sudo chmod 755 ./run_first.sh`
      - You will have to enter in your root password
   - enter in `./run_first.sh`
      - The scripts should now have full permission to run
2) If you're still getting "Permission denied" messages, try running `sudo ./convert_files.sh`. It's possible that your source directory requires higher permission levels to have the files copied.
