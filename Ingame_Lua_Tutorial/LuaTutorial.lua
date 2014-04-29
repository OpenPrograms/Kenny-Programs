local component = require("component")
local fs = require("filesystem")
local internet = require("internet")
local process = require("process")
local event = require("event")
local keyboard = require("keyboard")
local shell = require("shell")
local term = require("term")
local text = require("text")
local unicode = require("unicode")
local sides = require("sides")
local colors=require("colors")


local ul = {0x250C, 0x2554}
local ur = {0x2510, 0x2557}
local ll = {0x2514, 0x255A}
local lr = {0x2518, 0x255D}
local sl = {0x2502, 0x2551}
local al = {0x2500, 0x2550}

function getCh()
	return (select(4, event.pull("key_down")))
end


-- BaseLine Variables
CurrentChapter = 1
CurrentSection = 1
ChapterTitles = {
  "How to Create a Program",
  "How to Display and clear Text",
  "How to Use and Display Variables",
  "How to get User Input",
  "How to use IF statements",
  "How to use loops",
  "How to use redstone",
  "How to use redpower bundles",
  "How to use events",
  "How to use functions",
  "Extra Tips and Extra Functions"
  }

Chapter = {
  [1] = {
    "Key Points in this Chapter:\n\n1. Learning how to create a program.\n2. Learning how to save that program.\n3. Learning how to run that program.",
    "1.1 - Learning how to create a program.\n\nOk so first things first right? We gotta learn how to create our first program. Creating a program is very simple in OC.\n\nedit programname\n\nedit means we want to create or edit program, and programname is the name of the program we wish to edit or create.",
    "1.2 - Learning how to save that program.\n\nSo now your inside the editing feature of OC and you can move around almost like a notepad. We want to press the [Control] key which will bring up a menu at the bottom of your screen. Pressing CTRL - S [SAVE] will save the program. CTRL - W [EXIT] will exit editing the program.",
    "1.3 - Learning how to run that program.\n\nWe've created our little program, but how do we run it? Well thats simple. We type the program name into our terminal and press [ENTER], but remember all things in LUA are case-sensitive. Your program named \"Hello\" is not the same as your program named \"hello\".",
    "1.4 - Practice What We've Learned!\n\nYou'll see a new option at the bottom of your screen now. You can press [SPACE] to continue onward to the next chapter, you can also press [ENTER] to run this chapters simulation.\nDon't worry, you won't hurt my feelings by not practicing.",
    "SIM"
    },
  [2] = {
    "Key Points in this Chapter:\n\n1. How to use print\n2. How to use write\n3. How to clear the screen.\n4. How to use the cursor position.\n5. How to clear a specific line.",
    "2.1 - How to use print.\n\nTo show text to the user is a simple task. We do so by the following.\n\nprint (\"Hello User\")\n\nprint means to display the text to the user, and Hello User is the text we wish to display.",
    "2.2 - How to use write.\n\nWhen you print text, the program automatically adds a linebreak after your print command, sometimes you may not wish to do this.\n\nwrite (\"Hello\")\nprint (\"User\")\n\nThese two lines would make the exact same appearance as the print line we made previously. The reason is because the write command does not generate a linebreak and we can use this to keep our current position and continue writing on the same line.",
    "2.3 - How to clear the screen.\nQuite often you'll want to clear the screen automatically in your program.\n\nterm.clear()\n\nUsing this line we can clear the screen for our user to remove anything we don't want cluttering up the screen.",
    "2.4 - How to use the cursor position.\nThe cursor position is a very powerful thing. For example, when you clear the screen, the cursor still stays on it's previous line. Meaning that after you clear the screen, your next print statement very well may appear at the bottom of the screen.",
    "2.4 - How to use the cursor position.\nTo remedy this problem we've been given the command.\n\nterm.setCursor(1,1)\n\nThe first 1 in our statment is the horizontal position and the second 1 on our statement is the vertical posistion.",
    "2.4 - How to use the cursor position.\nBy using the term.setCursor(1,1) directly after a term.clear(), we can make sure that the next text we show the user appears at the top of his screen.\n\nRemember, lua is case sensitive. term.setCursor(1,1) is not right.",
    "2.5 - How to clear a specific line.\nBy using the term.setCursor we can create some pretty nifty tricks, like reprinting over lines already on the screen, or even clearing a certain line and printing something new.",
    "2.5 - How to clear a specific line.\nterm.setCursor(1,1)\nprint (\"You won't see this\")\nterm.setCursor(1,1)\nterm.clearLine()\nprint (\"Hello User\")\n\nWe used the term.clearLine() to remove the line at 1,1 and then we printed a new line where the old line used to be.",
    "2.6 - Practice What We've Learned!\n\nYou'll see a new option at the bottom of your screen now. You can press [SPACE] to continue onward to the next chapter, you can also press [ENTER] to run this chapters simulation.\nDon't worry, you won't hurt my feelings by not practicing.",
    "SIM"
    },
  [3] = {
    "Key Points in this Chapter:\n\n1. What is a variable\n2. How to use a variable\n3. How to display a variable\n4. How to convert a variable",
    "3.1 - What is a variable.\n\nThink of a variable as a container in which you can place text or a number. Using variables allows you to store information and modify it on the fly. Using variables correctly is the key to making a sucessful program.",
    "3.2 - How to use a variable.\n\nThe first thing we should almost always do when we want to use a variable in a program is to define the variable. We do this by giving the variable a default piece of data. If we don't define a variable then the variable is considered NIL until it has been set.",
    "3.2 - How to use a variable.\n\nA NIL variable can cause lots of problems in your program, if you try to add together 2 variables and one is NIL, you'll get an error, if you try printing a NIL variable you'll get an error.",
    "3.2 - How to use a variable.\n\nWe'll be using the variable x from this point onward. Remember that x is different then X in lua.\n\nx = 0\n\nThis defined x to have a default value of 0. You could also do x = \"hello\" if you wanted it to contain text.",
    "3.2 - How to use a variable.\n\nA variable will hold it's data until you change it. Therefor x = 0 means that x will be 0 until you tell your program that x is something different.",
    "3.2 - How to use a variable.\n\nYou can also set variables as booleans, booleans are true and false.\nx = true\nThis would set x to true, which is different then \"true\". Using booleans gives you 1 more way to define a variable to be used later in your program.",
    "3.3 - How to display a variable.\n\nBeing able to show a variable to the user is very important. Who wants to just save the user's name in a variable, but not show it to them during the program? When displaying variables we can use the print or write commands.",
    "3.3 - How to display a variable.\nx = 0\nprint (x)\nx = \"Bob\"\nprint (\"Hello\"..x)\n\nYou'll notice in the last line that we used our x variable along with another piece of text. To do so we used .. which tells the program to add the x variable directly after the word Hello. In this syntax that would show the user HelloBob since we didn't add a space ;)",
    "3.3 - How to display a variable.\n\nRemember variables are case sensitive, and that variable1 is different then Variable1.\nIf you wanted to place a variable inbetween text you could do.\n\nprint (\"Hello \"..x..\" how are you?\")\n\nThis would print Hello Bob how are you?",
    "3.4 - How to convert a variable.\n\nSometimes a variable might need to be converted, this is mainly the case when you want to use the variable as a number, but it's currently a string. For example:\nx = \"0\"\nx = x + 1\n\nThis will not work, as x equals \"0\"",
    "3.4 - How to convert a variable.\n\nThe difference between 0 and \"0\" is that one is a number and the other is a string. You can't use the basic math functions on strings. Lua can convert a number to a string automatically but it cannot convert a string to a number automatically.",
    "3.4 - How to convert a variable.\n\nx = 0\ny = \"1\"\nWe can't add those together atm, so we need to convert our string to a number so that we can add it to x.\ny = tonumber(y)\nThis converts y to a number (if it can't be converted to a number then y will be NIL)",
    "3.4 - How to convert a variable.\n\nNow that we've converted y to a number we can do.\nx = x + y\nThis would make x equal to x(0) + y(1). This means that x is now equal to 1 and y hasn't changed so it's still 1 as well.",
    "3.4 - How to convert a variable.\n\nIf we want to add a string to another string, we don't use the math symbols, we simply use ..\nx = \"Hello\"\ny = \"Bob\"\nx = x..y\nThis would make x = \"HelloBob\"",
    "3.4 - How to convert a variable.\n\nRemember that Lua can convert a number to a string, but not the other way around. If you always want to be 100% positive what your variables are, use the functions tonumber(x) and tostring(x).",
    "3.5 - Practice What We've Learned!\n\nYou'll see a new option at the bottom of your screen now. You can press [SPACE] to continue onward to the next chapter, you can also press [ENTER] to run this chapters simulation.\nDon't worry, you won't hurt my feelings by not practicing.",
    "SIM"	
    },
  [4] = {
    "Key Points in this Chapter:\n\n1. How to get user input",
    "4.1 - How to get user input.\n\nWhat's the point of having all these cool variables if your user can't make a variable be something they want? We fix this by allowing the user to input a variable into the program.",
    "4.1 - How to get user input.\n\nx = io.read()\nThe io.read() tells the program to stop and wait for user input, when the user presses enter that information is then stored in the variable x and the program continues.\nUser input is always stored as a string, therefor if the user types 1 and presses enter, x will be come \"1\", not 1",
    "4.1 - How to get user input.\n\nOnce the user's input is entered into the x variable you can use that variable like you would any other variable. This means if you then wanted to show the user their input you could follow your io.read() line with print(x)",
    "4.1 - How to get user input.\n\nBy using the write command before an io.read() we can show text then have the user type after that text.\nwrite(\"Enter Your Name -\"\nname = io.read()\nThis would have the user type their name directly after the - in the write statement.",
    "4.2 - Practice What We've Learned!\n\nYou'll see a new option at the bottom of your screen now. You can press [SPACE] to continue onward to the next chapter, you can also press [ENTER] to run this chapters simulation.\nDon't worry, you won't hurt my feelings by not practicing.",
    "SIM"	
    },
  [5] = {
    "Key Points in this Chapter:\n\n1. What is an IF statement\n2. The ELSE statement\n3. The ELSEIF statement\n4. Complex IF's",
    "5.1 - What is an IF statement.\n\nWe use IF statements to control the programs direction based on certain criteria that you define. Doing this allows us to do only certain things based on certain conditions.",
    "5.1 - What is an IF statement.\n\nif name == \"Bob\" then\nprint (\"Hello Again Bob\")\nend\n\nThe 1st line says, if the variable name is equal to \"Bob\" then enter this IF statement. The next line is the code that will run if name does equal Bob. The 3rd line says to end the IF statement, if the name was not Bob the program would skip to the line directly after end.",
    "5.1 - What is an IF statement.\n\nWe have many options in the IF statement, we could do:\nif x >= 1\nRemember we can't do that IF statement if x is a string x = \"1\".\nif name ~= \"Bob\"\nThe ~= option means is not equal too. This if statement would pass if the name was NOT Bob.",
    "5.2 - The ELSE statement.\n\nSometimes we want to do 1 thing if our IF statement is true and something else if it's false.\nif name == \"Bob\" then\nprint (\"Hello Bob\")\nelse\nprint(\"Your not Bob\")\nend\n\n",
    "5.2 - The ELSE statement.\n\nNotice how their is only 1 end statement as the last line of the entire IF statement. The ELSE line is a part of the current IF statement.",
    "5.3 - The ELSEIF statement.\n\nSometimes we want to check for multiple outcomes inside an IF statement, we can achieve this using the ELSEIF statement. The key things to remember is that you still only need 1 end as the last line, because this is 1 full statement, and that you will need to include a then for an ELSEIF.",
    "5.3 - The ELSEIF statement.\n\nif name == \"Bob\" then\nprint (\"Hello Bob\")\nelseif name == \"John\" then\nprint (\"Hello John\")\nelse\nprint (\"Hello Other\")\nend",
    "5.3 - The ELSEIF statement.\n\nI still included the final else, which tells the program if the name wasn't Bob or John, then do something else. Notice again that there was only a single end as the last line, because this was 1 full statement.",
    "5.4 - Complex IF's.\n\nIf's can become very complex depending on your situation. I will show some examples of more complex IF's:\nif name == \"Bob\" and name ~= \"John\" then\nWe are checking the variable twice in 1 if statement by using the AND statement. We could also use the OR statement",
    "5.4 - Complex IF's.\n\nYou can also place IF statements inside other IF statements, just make sure you place an END statement at the correct place for each IF statement. Next page is an example of a pretty complex IF statement.",
    "5.4 - Complex IF's.\nif name == \"Bob\" then\n if x == 1 then\n print(x)\n else\n print(\"Not 1\")\n end\nprint (\"Hi Bob\")\nelse\nprint (\"Your not Bob\")\nend",
    "5.4 - Complex IF's.\nWith precise placement of IF statements you can control the flow of your program to a great degree, this allows you to make sure the user is only seeing what you want them to see at all times.",
    "5.5 - Practice What We've Learned!\n\nYou'll see a new option at the bottom of your screen now. You can press [SPACE] to continue onward to the next chapter, you can also press [ENTER] to run this chapters simulation.\nDon't worry, you won't hurt my feelings by not practicing.",
    "SIM"	
    },
  [6] = {
    "Key Points in this Chapter:\n\n1.What is a loop\n2.How to exit a loop\n3.Different kinds of loops",
    "6.1 - What is a loop\n\nA loop is a section of code that will continually run until told otherwise. We use these to repeat the same code until we say otherwise.\n\nwhile true do\nend\n\nThis is a while loop that has no exit, it will continually run over and over again until the program crashes.",
    "6.2 - How to exit a loop\nSince we don't want our loops to run until they crash we have to give them a way to stop. We do this by using the BREAK command.The break command is mostly placed inside an IF statement as just placing it in the loop itself would break the loop right away.",
    "6.2 - How to exit a loop\n\nx = 0\nwhile true do\n x = x + 1\n if x == 10 then\n break\n end\nend\n\nNotice how are while statements have their own end? This would run the loop and continually add 1 to x until x == 10 then it will break out of the loop.",
    "6.3 - Different kinds of loops\n\nYou don't always need to use the BREAK command. You can also include a condition in the WHILE statement for how long to run the loop.\n\nx = 0\nwhile x < 10 do\nx = x + 1\nend\n\nWe could also end this early with a BREAK as well.",
    "6.3 - Different kinds of loops\n\nHeck we don't even have to use the WHILE statement to create a loop.\n\nfor x = 0, 10, 1 do\nprint (x)\nend\n\nThe first line says - x starts at 0, and continues until 10, increasing by 1 every time we come back to this line.",
    "6.3 - Different kinds of loops\n\nSo using the for statement we could do.\n\nx = 5\nfor x, 50, 5 do\nprint (x)\nend\n\nThis would printout 5 then 10 then 15 ect ect until reaching 50.",
    "6.4 - Practice What We've Learned!\n\nYou'll see a new option at the bottom of your screen now. You can press [SPACE] to continue onward to the next chapter, you can also press [ENTER] to run this chapters simulation.\nDon't worry, you won't hurt my feelings by not practicing.",
    "SIM"	
    },
  [7] = {
    "Key Points in this Chapter:\n\n1. Turning on and off redstone\n2. Checking and Setting Redstone",
    "7.1 - Turning on and off redstone\n\nOne of the greatest features of OC is that your computer can not only receive redstone signals, but it can also send them as well. We have 6 directions to choose from and they are:\ntop, bottom, front, back, left, right",
    "7.1 - Turning on and off redstone\n\nWe can control redstone with our computer using 2 basic commands, redstone.getInput(side) and redstone.setOutput(side, boolean).\nWe have to remember to place our sides in quotes though IE \"left\"",
    "7.2 - Checking and Setting Redstone\n\nredstone.setOutput(\"back\", true)\nThis tells the computer to turn on the redstone output on the back of the computer. We can replace true with false to turn off the redstone output to the back.",
    "7.2 - Checking and Setting Redstone\n\nif redstone.getInput(\"back\") == true then\nprint \"Redstone is on\"\nend\n\nThis would enter the IF statement if their was power running to the back of the computer.",
    "7.2 - Checking and Setting Redstone\n\nBy checking and setting different redstone sources while using IF statements we can control multiple things connected to our computer based on the redstone connections.",
    "7.3 - Practice What We've Learned!\n\nYou'll see a new option at the bottom of your screen now. You can press [SPACE] to continue onward to the next chapter, you can also press [ENTER] to run this chapters simulation.\nDon't worry, you won't hurt my feelings by not practicing.",
    "SIM"	
    },	
  [8] = {
    "Key Points in this Chapter:\n\n1. How to turn on a single color\n2. How to turn off a single color\n3. Using multiple colors\n4. Testing Inputs\n5. Turning off all colors.",
    "8.1 - How to turn on a single color\n\nrs.setBundledOutput(\"back\", colors.white)\n\nThis would turn on the white output in the back.",
    "8.2 - How to turn off a single color\n\nrs.setBundledOutput(\"back\", rs.getBundledOutput(\"back\") - colors.white)\n\n This would turn off only the color white in the back.",
    "8.3 - Using Multiple colors\nUsing multiple colors is much easier when you use the colors.combine colors.subtract functions.",
    "8.3 - Using Multiple colors\n\nout = colors.combine(colors.blue, colors.white)\nrs.setBundledOutput(\"back\", out)\n\nThis would turn on blue and white at the back\nout = colors.subtract(out, colors.blue)\nrs.setBundledOutput(\"back\", out)\nThis would turn off blue, but leave white on.",
    "8.4 - Testing Inputs\n\nin = rs.getBundledInput(\"back\")\nif colors.test(in, colors.white) == true then\n\nThis would get the current input and store it in the in variable. We then use colors.test on the in variable to see if white is on.",
    "8.5 - Turning off all colors\n\nrs.setBundledOutput(\"back\", 0)\n\nSetting the output to 0 is the quickest and most efficient way to turn off all colors at the same time.",
    "8.6 - Practice What We've Learned!\n\nYou'll see a new option at the bottom of your screen now. You can press [SPACE] to continue onward to the next chapter, you can also press [ENTER] to run this chapters simulation.\nDon't worry, you won't hurt my feelings by not practicing.",
    "SIM"	
    },
  [9] = {
    "Key Points in this Chapter:\n\n1. What is an event?\n2. How do we check for events\n3. What types of events are there?\n4. Using event loops\n5. WHATS GOING ON!",
    "9.1 - What is an event?\n\nAn event can be many things, from redstone to timers, as well as smashing your face on the keyboard. These can all trigger events within a program, and by correctly using the event.pull() command we can make sure that no matter what happens, we'll know about it!",
    "9.2 - How do we check for events\n\nevent, param1, param2 = event.pull()\n\nPlacing this line in your code will stop the program until ANY event triggers. So just by pressing a key, you will pass this statement because a keypress is an event",
    "9.2 - How do we check for events\n\nThe easiest way to check for an event happening is the IF statement.\n\nif event == \"char\" and param1 == \"q\" then\n This line would trigger if you pressed q on your keyboard.",
    "9.3 - What types of events are there\n\nchar - triggers on keypress\nkey - triggers on keypress\ntimer - triggers on a timer running out\nalarm - triggers on an alarm going off\nredstone - triggers on any change to redstone",
    "9.3 - What types of events are there\n\ndisk - triggers on disk insertion\ndisk_eject - triggers on disk ejection",
    "9.4 - Using event loops\n\nUsing the pullEvent() function inside a loop is a great way to determine when to break the loop. For instance:\n\nwhile true do\nevent, param1, param2 = event.pull()\n if event == \"char\" and param1 == \"q\" then\n break\n end\nend",
    "9.5 - WHATS GOING ON!\nThis is a cool test program to make, so that you can see exactly whats happening in events.\n\nwhile true do\nevent, param1, param2, param3 = event.pull()\nprint (\"Event = \"..event)\nprint (param1)\nprint (param2)\nprint (param3)\nend\n\nDon't Forget to Hold control+t to exit the loop.",
    "9.6 - Practice What We've Learned!\n\nYou'll see a new option at the bottom of your screen now. You can press [SPACE] to continue onward to the next chapter, you can also press [ENTER] to run this chapters simulation.\nDon't worry, you won't hurt my feelings by not practicing.",
    "SIM"
    },
  [10] = {
    "Key Points in this Chapter:\n\n1. What is a function?\n2. How to use a basic function\n3. How to get a return value from a function",
    "10.1 - What is a function\n\nThink of a function as a part of your code that can be ran from anywhere inside your code. Once your function is done running, it will take you back to where your code left off.",
    "10.2 - How to use a basic function\n\nfunction hello()\nprint (\"Hello\")\nend\n\n Here we created a function named hello, and inside that function we placed a print statement that says hello.",
    "10.2 - How to use a basic function\n\nNow that we have our function created, anytime and anywhere in our program, we can place\nhello()\nThis will jump to the function, run the functions code, then come back to where you called the function.",
    "10.3 - How to get a return value from a function\n\nMost of the time we want our functions to do repetitious tasks for us though, to do this we can create a more advanced function that will return a value based on what happens in the function.",
    "10.3 - How to get a return value from a function\n\nfunction add(num1, num2)\nresult = tonumber(num1) + tonumber(num2)\nreturn result\nend\n\nThis is our adding function, it takes 2 numbers that we supply and returns the result.",
    "10.3 - How to get a return value from a function\n\nTo call our adding function we use.\nx = add(5,5)\nThis makes the add function use the numbers 5 and 5, which it will then add together and return to us. We save that return data in x",
    "10.3 - How to get a return value from a function\n\nBy combining what we already know, we must assume that we can use variables instead of numbers in our function. Therefor making:\nx = add(x, y)\nA perfectly good way to add 2 variables together.",
    "10.4 - Practice What We've Learned!\n\nYou'll see a new option at the bottom of your screen now. You can press [SPACE] to continue onward to the next chapter, you can also press [ENTER] to run this chapters simulation.\nDon't worry, you won't hurt my feelings by not practicing.",
    "SIM"	
    },
  [11] = {
    "This is not a Chapter, this is just random blurbs of extra information about other features and functions.",
    "Blurb 0 (The Most Important) - Use NOTEPAD++ to edit your code, the in-game edit kinda sucks\n\nFind your code in saves/world/computer/#",
    "Blurb 1 - os.sleep(1) will pause your code for 1 second",
    "Blurb 2 - timername = os.startTimer(1) will cause a timer to go off in 1 second, use events to check for the name",
    "Blurb 3 - Making your code readable helps everyone\nwhile true do\nif x == 5 then\nend\nend\nCOULD BE\nwhile true do\n if x == 5 then\n end\nend",
    "Blurb 4 - Atleast 75% of the time, an error tells you exactly whats wrong with your program.\nSomething with NIL means your trying to use a NIL variable.",
    "Blurb 5 - Google Is your friend, just try \"lua strings tutorial\"",
    "Blurb 6 - Theres DOZENS of functions I didn't go over, you should read about them on the interwebs\nstring.len()\nstring.sub()\nstring.find()\nio.open()\nio.close()",
    "Blurb 7 - No one will help you if you don't work on the code yourself and provide them with it.",
    "Blurb 8 - When your ready for more advanced coding, start looking into the default programs as well as other user created content.",
    "Blurb 9 - Using matrice's is a good test to see if your grasping lua",
    "Blurb 10 - You don't have to use functions if you trully don't understand them, they can make your life easier, but they can also make your life much harder.",
    "Blurb 11 - Find help on IRC, but prepare to have code ready to be shown. http://webchat.esper.net/?channels=#oc",
    "Blurb 12 - You can do almost anything your imagination can think up.....except magic",
    "Blurb 13 - By holding Control+t you can terminate any program. By holding Control+r you can reboot any computer.",
    "END"
   }
  }
  
--"Event Checker""String Functions","File Functions","Math Functions","Calling Another Program","Disk Functions",
Examples = {
  [1] = {
    "Event Checker",
    "This example is a great way to check what event is being passed through the pullEvent() statement. It uses a while loop that continually checks the pull event until the q key is pressed.",
    [[
    term.clear()
    term.setCursor(1,1)
    while true do
      param1 = getCh()
      print (event)
      print (param1)
      print (param2)
      if event == "char" and param1 == "q" then
        break 
      end
    end
    ]],
    "eventchecker" -- filename to be saved as
    },
  [2] = {
    "String Functions",
    "This example uses some basic string functions to modify a string, we will take a long string and shorten it to 10 characters which will all be lowercased.",
    [[
    text = "Hello user and Welcome to the World of OpenComputers"
    blah = string.sub(text, 1, 10)
    -- This line says that blah is now equal to 1-10 of text.
    blah = string.lower(blah)
    -- This line says that blah is now equal to an all lowercase blah.
    print (blah)
    -- This outputs as hello user
    ]],
    "stringfunc"
    },
  [3] = {
    "File Functions",
    "This example will check to see if the file exists we will open it in \"r\" mode to read, it will then read line by line from the file and store that data into an array, we will then print each line of the file with a 1 second sleep between them. We can use the file:write(variable) statement if the file is opened in write mode \"w\". We can append a file with the \"wa\" mode.",
    [[
    filename = "tutorial"
    if fs.exists(filename) == true then
      file = io.open(filename, "r")
      local i = 1
      local line = {}
      while true do
        line[i] = file:read()
        if line[i] == nil then 
          break 
        end
        print (line[i])
        os.sleep (1)
        i = i + 1
      end
    else
      print ("File doesn't exist.")
    end
    ]],
    "filefunc"
    },
  [4] = {
    "Math Functions",
    "This tutorial will go over some of the math functions, we'll start with a random number from 1-10, we will then divide that by another random number from 1-20. We will take the result and round upwards to a whole number. Meaning that if our answer is 3.1 it will still round up to 4. You'll notice the math.ciel function which does our rounding, we could also use math.floor which would round down instead.",
    [[
    num1 = math.random(1,10)
    num2 = math.random(1,20)
    print ("Number 1 is "..num1)
    print ("Number 2 is "..num2)
    result = num1 / num2
    print ("UnRounded Result is "..result)
    result = math.ceil(result)
    print ("Rounded Up Result is "..result)
    ]],
    "mathfunc"
    },
  [5] = {
    "Calling Another Program",
    "This tutorial is very basic, but is a very powerful function as well. The shell.execute command allows us to run a command from within our program as if we were at the terminal.",
    [[
    shell.execute("programname")
    shell.execute("mkdir", nil, "testing")
    This would create a testing directory
    shell.execute("copy", "disk/hello", "world")
    This would copy the program hello from the disk directory
    and place it as a program called world in your root
    directory.
    ]],
    "callprogram"
    },
  [6] = {
    "Disk Functions",
    "This tutorial will go over some of the basic floppy functions. We will check to see if a floppy is inserted using the pullEvent() loop, we will then make sure the floppy doesn't have a label, and if it's label is empty we will label it Blank and exit the program. We can learn more about the disk functions by typing help disk at the terminal.",
    [[
    while true do
      local event, param1 = event.pull()
      if event == "disk" then
        if disk.getLabel(param1) == nil then
          disk.setLabel(param1, "Blank")
          print ("Disk labeled to Blank")
          print ("Disk is in the "..param1.." side")
          break
        else
          print ("Disk already has a label.")
          print ("Disk is in the "..param1.." side")
          break
        end
      end
    end
    ]],
    "diskfunc"
    }
  }

function SaveExamples()
  term.clear()
  term.setCursor(1,1)
  print "This will save all of the example programs into the examples folder."
  print ""
  print "You can access this folder by typing"
  print "cd examples"
  print "You can list the examples by typing"
  print "ls"
  print "You can simply edit the file to look"
  print "at it, or you can open the file inside"
  print "your computer by finding it in your"
  print "saves directory under your worldname"
  print "and the folder number of your hard drive."
  print ""
  pressany()
  os.sleep(.5)
  local path = fs.path(require("process").running())
  if fs.exists(path.."/examples") then
    print(" ")
  else
    fs.makeDirectory(path.."/examples")
  end
  
  local i = 1
  while true do
    if Examples[i] ~= nil then
      if fs.exists(path.."examples/"..Examples[i][4]) then
        print("Files already exist. exiting the save function")
        os.sleep(3)
        return
      end
      local file = io.open(path.."examples/"..Examples[i][4], "w")
      file:write("--[[\n")
      file:write(Examples[i][2])
      file:write("--]]\n")
      file:write(Examples[i][3])
      file:close()
      i = i + 1
    else
      break
    end
  end
  term.clear()
  term.setCursor(1,1)
  print "Examples correctly saved to /examples"
  pressany()
end

function spaces(cnt)
	return string.rep(string.char(32), cnt)
end

local function spChar(letter, cnt)
	return string.rep(unicode.char(letter), cnt)
end

function mainmenu()

  while true do
    term.clear()
    term.setCursor(1,1)
    
    print (spChar(ul[1], 1)..spChar(al[1],38)..spChar(ur[1], 1))
    print (spChar(sl[1], 1).."  OpenComputers Interactive Tutorial  "..spChar(sl[1], 1))
    print (spChar(sl[1], 1).."   By: Casper7526 (ported by Kenny)   "..spChar(sl[1], 1))
    print (spChar(0x251C, 1)..spChar(al[1],38)..spChar(0x2524, 1))
    print (spChar(sl[1], 1)..spaces(38)..spChar(sl[1], 1))
    print (spChar(sl[1], 1).."  1. Start                            "..spChar(sl[1], 1))
    print (spChar(sl[1], 1).."  2. Choose Chapter                   "..spChar(sl[1], 1))
    print (spChar(sl[1], 1).."  3. Examples                         "..spChar(sl[1], 1))
    print (spChar(sl[1], 1).."  4. Save Examples To File            "..spChar(sl[1], 1))
    print (spChar(sl[1], 1).."  5. Exit                             "..spChar(sl[1], 1))
    print (spChar(sl[1], 1)..spaces(38)..spChar(sl[1], 1))
    print (spChar(ll[1], 1)..spChar(al[1],38)..spChar(lr[1], 1))
    local param1 = getCh()
    if param1 == keyboard.keys["5"] then
      break
    elseif param1 == keyboard.keys["1"] then 
      chapter = 1 LoadChapter(chapter)
    elseif param1 == keyboard.keys["2"] then 
      ChooseChapter()
    elseif param1 == keyboard.keys["3"] then 
      ChooseExample()
    elseif param1 == keyboard.keys["4"] then 
      SaveExamples() 
    end
  end
end

function LoadExample(num)
  term.clear()
  term.setCursor(1,1)
  print (Examples[num][2])
  pressany()
  term.clear()
  os.sleep(.5)
  term.setCursor(1,1)
  print (Examples[num][3])
  pressany()
end

function ChooseExample()
  while true do
    term.clear()
    term.setCursor(1,1)
    print (spChar(ul[1], 1)..spChar(al[1],39)..spChar(ur[1], 1))
    print (spChar(sl[1], 1)..spaces(13).."Example Index"..spaces(13)..spChar(sl[1], 1))
    print (spChar(0x251C, 1)..spChar(al[1],39)..spChar(0x2524, 1))
    print (spChar(sl[1], 1)..spaces(39)..spChar(sl[1], 1))
    local i = 1
    while true do
      if Examples[i] == nil then 
        break 
      end
      print (spChar(sl[1],1).."  "..i..". "..text.trim(Examples[i][1])..spaces(34-string.len(text.trim(Examples[i][1])))..spChar(sl[1], 1))
      i = i + 1
    end
    print (spChar(sl[1], 1)..spaces(39)..spChar(sl[1], 1))
    print (spChar(sl[1], 1).."  q. Quit"..spaces(30)..spChar(sl[1], 1))
    print (spChar(sl[1], 1)..spaces(39)..spChar(sl[1], 1))
    print (spChar(ll[1], 1)..spChar(al[1],39)..spChar(lr[1], 1))
    term.write "Choice - "
    choice = io.read()
    if string.lower(choice) == "q" then 
      break 
    end
    if Examples[tonumber(choice)] == nil then 
      print "Thats not a valid chapter." os.sleep(1) 
    else
      LoadExample(tonumber(choice))
      break 
    end
  end
end



function ChooseChapter()
  while true do
    term.clear()
    term.setCursor(1,1)
    print (spChar(ul[1], 1)..spChar(al[1],39)..spChar(ur[1], 1))
    print (spChar(sl[1], 1)..spaces(13).."Chapter Index"..spaces(13)..spChar(sl[1], 1))
    print (spChar(0x251C, 1)..spChar(al[1],39)..spChar(0x2524, 1))
    print (spChar(sl[1], 1)..spaces(39)..spChar(sl[1], 1))
    local i = 1
    while true do
      if ChapterTitles[i] == nil then
        break
      end
      if i < 10 then
        spStr = 34
      else
        spStr = 33
      end
      print (spChar(sl[1],1).."  "..i..". "..text.trim(ChapterTitles[i])..spaces(spStr-string.len(text.trim(ChapterTitles[i])))..spChar(sl[1], 1))
      i = i + 1
    end
    print (spChar(sl[1], 1)..spaces(39)..spChar(sl[1], 1))
    print (spChar(sl[1], 1).."  q. Quit"..spaces(30)..spChar(sl[1], 1))
    print (spChar(sl[1], 1)..spaces(39)..spChar(sl[1], 1))
    print (spChar(ll[1], 1)..spChar(al[1],39)..spChar(lr[1], 1))
    term.write "Choice - "
    choice = io.read()
    if string.lower(choice) == "q" then 
      break 
    end
    if ChapterTitles[tonumber(choice)] == nil then 
      print "Thats not a valid chapter." os.sleep(1) 
    else
      LoadChapter(tonumber(choice)) 
      break 
    end
  end
end

function LoadChapter(chapter)
  while true do
    term.clear()
    term.setCursor(1,1)
    local spStr = 35
    if chapter > 10 then
      spStr = 34
    end
    print (spChar(ul[1], 1)..spChar(al[1],50)..spChar(ur[1], 1))
    print (spChar(sl[1], 1)..spaces(3).."Chapter "..chapter.." - "..ChapterTitles[chapter]..spaces(spStr-string.len(ChapterTitles[chapter]))..spChar(sl[1], 1))
    print (spChar(ll[1], 1)..spChar(al[1],50)..spChar(lr[1], 1))
    print ("   "..Chapter[chapter][CurrentSection])
    print ""
    if Chapter[chapter][CurrentSection + 1] == "END" then 
      print "THATS ALL FOLKS!" 
    else
      print "Press [Space] To Continue"
    end
    print "[q] - Main Menu [b] - Previous Page."
    if Chapter[chapter][CurrentSection + 1] == "SIM" then 
      print "Press [Enter] To Run Simulation" 
    end
    local param1 = getCh()
    if param1 == keyboard.keys.enter and Chapter[chapter][CurrentSection + 1] == "SIM" then 
      Sim(chapter) EndSim(chapter) chapter = chapter + 1 CurrentSection = 1 
    elseif param1 == keyboard.keys.q then 
      CurrentSection = 1 
      break 
    elseif param1 == keyboard.keys.b then
      CurrentSection = CurrentSection - 1
      if CurrentSection == 0 then 
        CurrentSection = 1 
      end
    elseif param1 == keyboard.keys.space and Chapter[chapter][CurrentSection + 1] ~= "END" then
      if Chapter[chapter][CurrentSection + 1] == "SIM" then 
        chapter = chapter + 1 CurrentSection = 1 
      else 
        CurrentSection = CurrentSection + 1 
      end
    end
  end
end

function EndSim(chapter)
  while true do
    term.clear()
    term.setCursor(1,1)
    print "Great work back there!"
    print ""
    print "Press [ENTER] to move on to the next chapter"
    local param1 = getCh()
    if param1 == keyboard.keys.enter then 
      shell.execute("rm", nil, "tmptut") 
      break 
    end
  end
end

function pressany()
  term.setCursor(1,17)
  print "Press Any Key To Continue"
  pause=getCh()
end

function Sim(chapter)
  stage = 1
  while true do
    term.clear()
    term.setCursor(1,1)
    if chapter == 1 then
      print "Your Goals:"
      print ""
      print "* Create a program named hello."
      print "* Type anything you wish inside that program."
      print "* Save and Exit the program."
      print "* Run the program."
      print ""
      print "quit will exit the sim early."
      term.write (">") 
      input = io.read()
      if input == "quit" then 
        break 
      end
      if stage == 1 then
        if input == "edit hello" then
          shell.execute("edit", nil, "tmptut")
          print "Great Job, now let's run our program!"
          os.sleep(2)
          stage = 2
        else
          print "Remember, lua is case sensitive."
          print "Try"
          print "edit hello"
          os.sleep(2)	
        end
      elseif stage == 2 then
        if input == "hello" then 
          break
        else
          print "Remember, lua is case sensitive."
          print "Try"
          print "hello"
          os.os.sleep(2)	
        end
      end
    end
    if chapter == 2 then
      print "Your Goals:"
      print ""
      print "* Create a program named hello."
      print "* Clear the Screen"
      print "* Set the Cursor Pos to 1,1"
      print "* Print \"Hello Loser\" on line 1 of the screen."
      print "* Print \"Welcome\" on line 2 of the screen."
      print "* Clear the 1st line."
      print "* Print \"Hello User\" on line 1 of the screen."
      print "* Run your program!"
      print ""
      print "You can type \"example\" at anytime to see the correct syntax."
      print "quit will exit the sim early."
      print ""
      term.write (">") 
      input = io.read()
      if input == "quit" then 
        break 
      elseif input == "edit hello" then 
        shell.execute("edit", nil, "tmptut") 
      elseif input == "hello" then 
        shell.execute("tmptut") 
        pressany()
        term.clear()
        term.setCursor(1,1)
        print "Did your program work as you expected?"
        print ""
        print "Press [ENTER] to end the simulation."
        print "Press Any Other Key to go back and work on your program."
        param1 = getCh()
        if param1 == keyboard.keys.enter then 
          break 
        end
      elseif string.lower(input) == "example" then
        term.clear()
        term.setCursor(1,1)
        print ("term.clear()")
        print ("term.setCursor(1,1)")
        print ("print (\"Hello Loser\")")
        print ("print (\"Welcome\")")
        print ("term.setCursor(1,1)")
        print ("term.clearLine()")
        print ("print (\"Hello User\")")
        pressany()
      end
    end
    if chapter == 3 then
      print "Your Goals:"
      print ""
      print "--Use the program hello--"
      print "* Create the following variables."
      print " x = 1"
      print " y = \"2\""
      print " z = 0"
      print " text = \"Output \""
      print "* Add x and y together and store that value in z, then print text and z to the user on the same line."
      print "* Run your program!"
      print ""
      print "You can type \"example\" at anytime to see the correct syntax."
      print "quit will exit the sim early."
      print ""
      term.write (">") 
      input = io.read()
      if input == "quit" then 
        break 
      elseif input == "edit hello" then 
        shell.execute("edit", nil, "tmptut") 
      elseif input == "hello" then 
        shell.execute("tmptut") 
        pressany()
        term.clear()
        term.setCursor(1,1)
        print "Did your program work as you expected?"
        print ""
        print "Press [ENTER] to end the simulation."
        print "Press Any Other Key to go back and work on your program."
        param1 = getCh()
        if param1 == keyboard.keys.enter then 
          break 
        end
      elseif string.lower(input) == "example" then
        term.clear()
        term.setCursor(1,1)
        print ("term.clear()")
        print ("term.setCursor(1,1)")
        print ("x = 1")
        print ("y = \"2\"")
        print ("z = 0")
        print ("text = \"Output \"")
        print ("y = tonumber(y)")
        print ("z = x + y")
        print ("print (text..z)")
        pressany()
      end
    end
    if chapter == 4 then
      print "Your Goals:"
      print ""
      print "--Use the program hello--"
      print "* Ask the user for their name"
      print "* Show them the line:"
      print " Hello name how are you today?"
      print " With name replaced by their input."
      print "* Run your program!"
      print ""
      print "You can type \"example\" at anytime to see the correct syntax."
      print "quit will exit the sim early."
      print ""
      term.write (">") 
      input = io.read()
      if input == "quit" then 
        break 
      elseif input == "edit hello" then 
        shell.execute("edit", nil, "tmptut") 
      elseif input == "hello" then 
        shell.execute("tmptut") 
        pressany()
        term.clear()
        term.setCursor(1,1)
        print "Did your program work as you expected?"
        print ""
        print "Press [ENTER] to end the simulation."
        print "Press Any Other Key to go back and work on your program."
        param1 = getCh()
        if param1 == keyboard.keys.enter then 
          break 
        end
      elseif string.lower(input) == "example" then
        term.clear()
        term.setCursor(1,1)
        print ("term.clear()")
        print ("term.setCursor(1,1)")
        print ("write(\"Whats your name? \")")
        print ("name = io.read()")
        print ("print (\"Hello \"..name..\" how are you today?\")")
        pressany()
      end
    end
    if chapter == 5 then
      print "Your Goals:"
      print ""
      print "--Use the program hello--"
      print "* Ask the user for their name"
      print "* If their name is Bob or John then welcome them."
      print "* If their name isn't Bob or John, then tell them to get lost!"
      print "* Run your program!"
      print ""
      print "You can type \"example\" at anytime to see the correct syntax."
      print "quit will exit the sim early."
      print ""
      term.write (">") 
      input = io.read()
      if input == "quit" then 
        break 
      elseif input == "edit hello" then 
        shell.execute("edit", nil, "tmptut") 
      elseif input == "hello" then 
        shell.execute("tmptut") 
        pressany()
        term.clear()
        term.setCursor(1,1)
        print "Did your program work as you expected?"
        print ""
        print "Press [ENTER] to end the simulation."
        print "Press Any Other Key to go back and work on your program."
        param1 = getCh()
        if param1 == keyboard.keys.enter then 
          break 
        end
      elseif string.lower(input) == "example" then
        term.clear()
        term.setCursor(1,1)
        print ("term.clear()")
        print ("term.setCursor(1,1)")
        print ("write(\"Whats your name? \")")
        print ("name = io.read()")
        print ("if name == \"Bob\" or name == \"John\" then ")
        print ("print (\"Welcome \"..name)")
        print ("else")
        print ("print (\"Get lost!\")")
        print ("end")
        pressany()
      end
    end
    if chapter == 6 then
      print "Your Goals:"
      print ""
      print "--Use the program hello--"
      print "* Create a loop that continually asks the user for their name."
      print "* Only exit that loop if they enter Bob as their name."
      print "* Try using the BREAK statement as well as without."
      print "* Run your program!"
      print ""
      print "You can type \"example\" at anytime to see the correct syntax."
      print "quit will exit the sim early."
      print ""
      term.write (">") 
      input = io.read()
      if input == "quit" then 
        break 
      elseif input == "edit hello" then 
        shell.execute("edit", nil, "tmptut") 
      elseif input == "hello" then 
        shell.execute("tmptut") 
        pressany()
        term.clear()
        term.setCursor(1,1)
        print "Did your program work as you expected?"
        print ""
        print "Press [ENTER] to end the simulation."
        print "Press Any Other Key to go back and work on your program."
        param1 = getCh()
        if param1 == keyboard.keys.enter then 
          break 
        end
      elseif string.lower(input) == "example" then
        term.clear()
        term.setCursor(1,1)
        print ("term.clear()")
        print ("term.setCursor(1,1)")
        print ""
        print ("while name ~= \"Bob\" do")
        print ("write(\"Whats your name? \")")
        print ("name = io.read()")
        print ("end")
        print ""
        print ("while true do")
        print ("write(\"Whats your name? \")")
        print ("name = io.read()")
        print (" if name == \"Bob\" then")
        print (" break")
        print (" end")
        print ("end")
        pressany()
      end
    end
    if chapter == 7 then
      print "Your Goals:"
      print ""
      print "--Use the program hello--"
      print "* Check to see if there is redstone current coming into the back of your computer"
      print "* If there is current coming in the back then turn on the current to the front"
      print "* If there isn't current coming in the back, then turn off the current to the front"
      print "* Tell the user if you turned the current on or off."
      print "* Run your program!"
      print ""
      print "You can type \"example\" at anytime to see the correct syntax."
      print "quit will exit the sim early."
      print ""
      term.write (">") 
      input = io.read()
      if input == "quit" then
        break 
      elseif input == "edit hello" then 
        shell.execute("edit", nil, "tmptut") 
      elseif input == "hello" then 
        shell.execute("tmptut") 
        pressany()
        term.clear()
        term.setCursor(1,1)
        print "Did your program work as you expected?"
        print ""
        print "Press [ENTER] to end the simulation."
        print "Press Any Other Key to go back and work on your program."
        local param1 = getCh()
        if param1 == keyboard.keys.enter then 
          break 
        end
      elseif string.lower(input) == "example" then
        term.clear()
        term.setCursor(1,1)
        print ("term.clear()")
        print ("term.setCursor(1,1)")
        print ("if redstone.getInput(\"back\") == true then")
        print ("redstone.setOutput(\"front\", true)")
        print ("print (\"Front is now on.\")")
        print ("else")
        print ("redstone.setOutput(\"front\", false)")
        print ("print (\"Front is now off.\")")
        print ("end")
        pressany()
      end
    end
    if chapter == 8 then
      print "Your Goals:"
      print ""
      print "--Use the program hello--"
      print "--Use the back output of the computer--"
      print "* Turn on white"
      print "* Turn on blue"
      print "* Turn on purple"
      print "* Turn off blue"
      print "* Turn off all colors"
      print "* Check to see if white is coming in the front"
      print "* Run your program!"
      print ""
      print "You can type \"example\" at anytime to see the correct syntax."
      print "quit will exit the sim early."
      print ""
      term.write (">") 
      input = io.read()
      if input == "quit" then 
        break 
      elseif input == "edit hello" then 
        shell.execute("edit", nil, "tmptut") 
      elseif input == "hello" then 
        shell.execute("tmptut") 
        pressany()
        term.clear()
        term.setCursor(1,1)
        print "Did your program work as you expected?"
        print ""
        print "Press [ENTER] to end the simulation."
        print "Press Any Other Key to go back and work on your program."
        local param1 = getCh()
        if param1 == keyboard.keys.enter then 
          break 
        end
      elseif string.lower(input) == "example" then
        term.clear()
        term.setCursor(1,1)
        print ("term.clear()")
        print ("term.setCursor(1,1)")
        print ("out = colors.combine(colors.white, colors.blue, colors.purple)")
        print ("rs.setBundledOutput(\"back\", out)")
        print ("out = colors.subtract(out, colors.blue)")
        print ("rs.setBundledOutput(\"back\", out)")
        print ("rs.setBundledOutput(\"back\", 0)")
        print ("in = rs.getBundledInput(\"front\")")
        print ("if colors.test(in, colors.white) == true then")
        print ("print (\"White is on in front\")")
        print ("else")
        print ("print (\"White is off in front\")")
        print ("end")
        pressany()
      end
    end
    if chapter == 9 then
      print "Your Goals:"
      print ""
      print "--Use the program hello--"
      print "* Create an event loop"
      print "* Print the char that was pressed"
      print "* Stop the loop when the q key is pressed"
      print "* Stop the loop if the redstone event happens"
      print "* Run your program!"
      print ""
      print "You can type \"example\" at anytime to see the correct syntax."
      print "quit will exit the sim early."
      print ""
      term.write (">") 
      input = io.read()
      if input == "quit" then 
        break 
      elseif input == "edit hello" then 
        shell.execute("edit", nil, "tmptut") 
      elseif input == "hello" then 
        shell.execute("tmptut") 
        pressany()
        term.clear()
        term.setCursor(1,1)
        print "Did your program work as you expected?"
        print ""
        print "Press [ENTER] to end the simulation."
        print "Press Any Other Key to go back and work on your program."
        local param1 = getCh()
        if param1 == keyboard.keys.enter then 
          break 
        end
      elseif string.lower(input) == "example" then
        term.clear()
        term.setCursor(1,1)
        print ("term.clear()")
        print ("term.setCursor(1,1)")
        print ("while true do")
        print ("event, param1, param2 = event.pull()")
        print (" if event == \"redstone\" then")
        print (" break")
        print (" end")
        print (" if event == \"char\" and param1 == \"q\" then")
        print (" break")
        print (" else")
        print (" print (\"You pressed - \"..param1)")
        print (" end")
        print ("end")
        pressany()
      end
    end
    if chapter == 10 then
      print "Your Goals:"
      print ""
      print "--Use the program hello--"
      print "* Ask the user for their first name."
      print "* Ask the user for their last name."
      print "* Combine the 2 strings using a function"
      print " return the result into the fullname variable"
      print "* Show the user their full name"
      print "* Run your program!"
      print ""
      print "You can type \"example\" at anytime to see the correct syntax."
      print "quit will exit the sim early."
      print ""
      term.write (">") 
      input = io.read()
      if input == "quit" then 
        break 
      elseif input == "edit hello" then 
        shell.execute("edit", nil, "tmptut") 
      elseif input == "hello" then 
        shell.execute("tmptut") 
        pressany()
        term.clear()
        term.setCursor(1,1)
        print "Did your program work as you expected?"
        print ""
        print "Press [ENTER] to end the simulation."
        print "Press Any Other Key to go back and work on your program."
        local param1 = getCh()
        if param1 == keyboard.keys.enter then 
          break 
        end
      elseif string.lower(input) == "example" then
        term.clear()
        term.setCursor(1,1)
        print ("term.clear()")
        print ("term.setCursor(1,1)")
        print ("function combine(s1, s2)")
        print ("result = s1..s2")
        print ("return result")
        print ("end")
        print ("write(\"What's your first name? \")")
        print ("firstname = io.read()")
        print ("write(\"What's your last name? \")")
        print ("lastname = io.read()")
        print ("fullname = combine(firstname, lastname)")
        print ("print (\"Hello \"..fullname)")
        pressany()
      end
    end
  end
end

mainmenu()
