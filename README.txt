Please refer to the BYON webpage before running this code. It has more relevant information about BYON (https://robertomochetti.com/works/byon.html)

How to Use This Code

OBS: The files "BYON – Video" and "BYON - Music" are only shortcuts to, respectvely, BYON_processing_code/BYON_processing_code.pde and BYON_prurr-data_code/BYON.pd . This is to make running this code more convenient but, if the shortcuts do not work, you can run it by opening the files directly.

Firstly, make sure that "BYON - Music" is opened in Purr Data or any version of Pure Data with the else, cyclone, and maxlib libraries. If you are not interested in the graphics, you can input the number in the empty message box and click on the large green [bang] under it. The music should start in 10 seconds if you increase the output volume in the patch.

If you want to see graphics in real time, run the Java code in "BYON – Video" application after "BYON - Music" is already opened (you will need Processing installed for this). In this case, don’t type any number or do anything in the Pure Data patch, it only needs to be opened. Once the Processing code is running, make sure to toggle the Connect OSC button. If the status says connected, type a number on the text box and click the OK button. The music and graphics should start in about 10 seconds. 

These instructions are valid if audio and video are being generated on the same computer, which can be a little heavy. If you want to use different computers for audio and video, please follow the instructions below:
1.	Make sure that, in addition to Purr Data or equivalent, you have Processing installed on your computer.
2.	Open BYON – Music, click on the object [pd OSCY] around the upper right corner of the patch. 
3.	In the message box where it says, “connect localhost 12000”, substitute the word “localhost” with the IP address of the computer running graphics. Make sure both machines are under the same Wi-Fi network.
4.	Inside the directory /BYON_processing_code, open the file BYON_processing_code.pde, and edit line 27, “myBroadcastLocation = new NetAddress("localhost", 8000);”, substituting the word “localhost” with the IP address of the computer running Purr Data.

If you have any questions, please contact me at robertocmochetti@gmail.com
