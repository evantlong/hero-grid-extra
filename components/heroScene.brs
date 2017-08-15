' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

' 1st function that runs for the scene on channel startup
Function init()
  'To see print statements/debug info, telnet on port 8089
  'print "HeroScene.brs - [init]"
  ' HeroScreen Node with RowList

  m.top.observeField("visible", "onVisibleChange")
  m.top.observeField("focusedChild", "OnFocusedChildChange")
  m.buttons = m.top.findNode("Buttons")
  'm.herobuttons = m.top.findNode("HeroButtons")
  m.HeroScreen = m.top.FindNode("HeroScreen")
  m.stars = m.top.FindNode("Stars")
  m.DetailsScreen = m.top.FindNode("DetailsScreen")
  ' The spinning wheel node
  m.LoadingIndicator = m.top.findNode("LoadingIndicator")
  ' Dialog box node. Appears if content can't be loaded
  m.WarningDialog = m.top.findNode("WarningDialog")
  ' Transitions between screens
  m.Black = m.top.findNode("Black")
  m.FadeIn = m.top.findNode("FadeIn")
  m.FadeOut = m.top.findNode("FadeOut")
  m.SearchKeyboard = m.top.findNode("SearchKeyboard")
  m.KeyboardScene = m.top.findNode("KeyboardScene")
  ' Set focus to the scene
  m.top.setFocus(true)

  'result = []
  'for each button in ["About"]
  '  result.push({title : button})
  'end for
  'm.herobuttons.content = ContentList2SimpleNode(result)

  result = []
  for each button in ["Search", "Exit"]
  	result.push({title : button})
  end for
  m.buttons.content = ContentList2SimpleNode(result)

  result = []
  for each button in [""]
  result.push({title : button})
  end for
  m.stars.content = ContentList2SimpleNode(result)

end function

Sub onItemSelected()
  print "DetailsScreen.brs - [onItemSelected]"
    ' first button is Search
    if m.top.itemSelected = 0
    	print "SEARCH WAS SELECTED!"
	'do search stuff here
	print m.SearchKeyboard.textEditBox.Text
	'second button is exit
    else if m.top.itemSelected = 1
    	print "EXIT WAS SELECTED"
	m.FadeOut.control = "start"
	m.Black.visible = "false"
	m.HeroScreen.visible = "true"
	m.SearchKeyboard.visible = "false"
	m.buttons.visible = "false"
	m.HeroScreen.setFocus(true)
	m.buttons.setFocus(false)
	m.SearchKeyboard.setFocus(false)
	m.stars.visible = "false"
	m.stars.setFocus(false)
	result = true
    else if m.top.itemSelected > 1
	print "STARS  WAS  PRESSED"
    'else if m.herobuttons.itemSelected = 0
     'print "ABOUT WAS PRESSED!"
    end if
End Sub

' Hero Grid Content handler fucntion. If content is set, stops the
' loadingIndicator and focuses on GridScreen.
sub OnChangeContent()
  'print "HeroScene.brs - [OnChangeContent]"
  m.loadingIndicator.control = "stop"
  if m.top.content <> invalid
    'Warn the user if there was a bad request
    if m.top.numBadRequests > 0
      m.HeroScreen.visible = "true"
      m.WarningDialog.visible = "true"
      m.WarningDialog.message = (m.top.numBadRequests).toStr() + " request(s) for content failed. Press '*' or OK or '<-' to continue."
    else
      m.HeroScreen.visible = "true"
      m.HeroScreen.setFocus(true)
    end if
  else
    m.WarningDialog.visible = "true"
  end if
end sub

' Row item selected handler function.
' On select any item on home scene, show Details node and hide Grid.
sub OnRowItemSelected()
  'print "HeroScene.brs - [OnRowItemSelected]"
  m.FadeIn.control = "start"
  m.HeroScreen.visible = "false"
  m.DetailsScreen.content = m.HeroScreen.focusedContent
  m.DetailsScreen.setFocus(true)
  m.DetailsScreen.visible = "true"
  m.stars.visible = "true"
end sub

' Called when a key on the remote is pressed
function onKeyEvent(key as String, press as Boolean) as Boolean
  print ">>> HomeScene >> OnkeyEvent"
  result = false
  print "in HeroScene.xml onKeyEvent ";key;" "; press
  if press then
    if key = "options"
    'take you to the search screen
      if m.HeroScreen.visible = true and m.SearchKeyboard.visible = false
		print "------ [options pressed] ------"
      	m.FadeIn.control = "start"
		m.HeroScreen.visible = "false"
		m.Black.visible = "true"
		m.SearchKeyboard.setFocus(true)
		m.SearchKeyboard.visible = "true"
	     m.SearchKeyboard.textEditBox.hintText="Enter Text Here"
		m.buttons.setFocus(false)
		m.buttons.visible = "true"
		result = true
	'takes you back to the hero screen	
      else if m.SearchKeyboard.visible = true and m.HeroScreen.visible = false
	     print "------ [options pressed] ------"
		m.FadeOut.control = "start"
		m.Black.visible = "false"
		m.HeroScreen.visible = "true"
		m.SearchKeyboard.visible = "false"
	     m.buttons.visible = "false"
	     m.HeroScreen.setFocus(true)
		m.buttons.setFocus(false)
		m.SearchKeyboard.setFocus(false)
		result = true
      end if
	'on search screen, takes you to the keyboard if on the buttons 
    else if key = "up" 
    	 if m.buttons.setFocus(true) and m.SearchKeyboard.visible = true
	     print "-----UP PRESSED TO SEARCH-----"
		m.SearchKeyboard.setFocus(true)
		m.buttons.setFocus(false)
		result = true
	  else if m.SearchKeyboard.visible = false and m.HeroScreen.visible = true
	     m.HeroScreen.setFocus(true)
	  '  m.herobuttons.visible = "true"
	  '	m.herobuttons.setFocus(true)
	  ' 	m.HeroScreen.setFocus(false)
	  '	result = true						   
	 else if m.detailsScreen.visible = true and m.stars.setFocus(true)
	     m.stars.setFocus(false)
		m.detailsScreen.setFocus(true)
		result = true
	 end if
	 'on search screen, takes to the buttons if on the keyboard
    else if key = "down"
    	 if m.SearchKeyboard.setFocus(true) and m.buttons.visible = true
	 	print "-----DOWN PRESSED TO SELECT-----"
		m.buttons.setFocus(true)
		m.SearchKeyboard.setFocus(false)
		result = true
      'else if m.SearchKeyboard.visible = false and m.HeroScreen.visible = true
	 '    m.herobuttons.visible = "false"
	 ' 	m.herobuttons.setFocus(false)
	 ' 	m.HeroScreen.setFocus(true)
	 '	result = true
      else if m.detailsScreen.visible = true and m.stars.setFocus(false)
	     m.stars.setFocus(true)
	     m.detailsScreen.setFocus(false)
		result = true
	 end if	
    else if key = "right" 
      if m.stars.setFocus(true) and m.buttons.visible = false 'm.herobuttons.visible = false
      print "----- right pressed -----"
	   if m.stars.setFocus(true) and m.stars.focusBitmapUri="pkg:/images/Star_rating_0_of_5.png"
          m.stars.focusBitmapUri="pkg:/images/Star_rating_1_of_5.png"
        else if m.stars.setFocus(true) and m.stars.focusBitmapUri="pkg:/images/Star_rating_1_of_5.png"
	     m.stars.focusBitmapUri="pkg:/images/Star_rating_2_of_5.png"
        else if m.stars.setFocus(true) and m.stars.focusBitmapUri="pkg:/images/Star_rating_2_of_5.png"
	     m.stars.focusBitmapUri="pkg:/images/Star_rating_3_of_5.png"
        else if m.stars.setFocus(true) and m.stars.focusBitmapUri="pkg:/images/Star_rating_3_of_5.png"
          m.stars.focusBitmapUri="pkg:/images/Star_rating_4_of_5.png"
        else if m.stars.setFocus(true) and m.stars.focusBitmapUri="pkg:/images/Star_rating_4_of_5.png"
	     m.stars.focusBitmapUri="pkg:/images/Star_rating_5_of_5.png"
        else if m.stars.setFocus(true) and m.stars.focusBitmapUri="pkg:/images/Star_rating_5_of_5.png"
	     m.stars.focusBitmapUri="pkg:/images/Star_rating_0_of_5.png"
        end if
      else if m.buttons.visible = true 
	   print "_-_-_-_-_-_- right pressed on search screen -_-_-_-_-_-_"
        m.stars.visible = "false"
	   m.stars.setFocus(false)
	   m.SearchKeyboard.setFocus(true)
	   result = true
	 'else if m.herobuttons.setFocus(true)
       ' print "_-_-_-_-_-_- right pressed on ABOUT  screen -_-_-_-_-_-_"
	  ' m.stars.visible = "false"
	  ' m.stars.setFocus(false)
	  ' m.herobuttons.setFocus(true)
	 end if
    else if key = "left" 
      if m.stars.setFocus(true) and m.buttons.visible = false 'm.herobuttons.visible = false
      print "----- left pressed -----"
	   if m.stars.setFocus(true) and m.stars.focusBitmapUri="pkg:/images/Star_rating_0_of_5.png"
	     m.stars.focusBitmapUri="pkg:/images/Star_rating_5_of_5.png"
	   else if m.stars.setFocus(true) and m.stars.focusBitmapUri="pkg:/images/Star_rating_1_of_5.png"
	     m.stars.focusBitmapUri="pkg:/images/Star_rating_0_of_5.png"
	   else if m.stars.setFocus(true) and m.stars.focusBitmapUri="pkg:/images/Star_rating_2_of_5.png"
	     m.stars.focusBitmapUri="pkg:/images/Star_rating_1_of_5.png"
	   else if m.stars.setFocus(true) and m.stars.focusBitmapUri="pkg:/images/Star_rating_3_of_5.png"
	     m.stars.focusBitmapUri="pkg:/images/Star_rating_2_of_5.png"
	   else if m.stars.setFocus(true) and m.stars.focusBitmapUri="pkg:/images/Star_rating_4_of_5.png"
	     m.stars.focusBitmapUri="pkg:/images/Star_rating_3_of_5.png"
	   else if m.stars.setFocus(true) and m.stars.focusBitmapUri="pkg:/images/Star_rating_5_of_5.png"
	     m.stars.focusBitmapUri="pkg:/images/Star_rating_4_of_5.png"
	   end if
	 else if m.buttons.visible = true
	   print "_-_-_-_-_-_- left pressed on search screen -_-_-_-_-_-_"
        m.stars.visible = "false"
        m.stars.setFocus(false)
	   m.SearchKeyboard.setFocus(true)
	   result = true
      'else if m.herobuttons.setFocus(true)
	 '  print "_-_-_-_-_-_- left pressed on ABOUT  screen -_-_-_-_-_-_"
	 '  m.stars.visible = "false"
	 '  m.stars.setFocus(false)
	 '  m.herobuttons.setFocus(true)
	 end if
    else if key = "back"
      print "------ [back pressed] ------"
	 ' if WarningDialog is open
      if m.WarningDialog.visible = true
        m.WarningDialog.visible = "false"
        m.HeroScreen.setFocus(true)
        result = true
	'if Search open   
	 else if m.HeroScreen.visible = false and m.SearchKeyboard.visible = true
	 print "------ [back pressed for search] ------"
	 m.FadeOut.control = "start"
	 m.Black.visible = "false"
	 m.HeroScreen.visible = "true"
	 m.SearchKeyboard.visible = "false"
	 m.buttons.visible = "false"
	 m.HeroScreen.setFocus(true)
	 m.buttons.setFocus(false)
	 m.SearchKeyboard.setFocus(false)
	 result = true
	 ' if Details opened
      else if m.HeroScreen.visible = false and m.DetailsScreen.videoPlayerVisible = false
        m.FadeOut.control = "start"
        m.HeroScreen.visible = "true"
        m.detailsScreen.visible = "false"
        m.HeroScreen.setFocus(true)
        m.stars.visible = "false"
	   m.stars.setFocus(false)
	   result = true
      ' if video player opened
      else if m.HeroScreen.visible = false and m.DetailsScreen.videoPlayerVisible = true
        m.DetailsScreen.videoPlayerVisible = false
        m.stars.visible = "true"
	   result = true
      end if
    else if key = "OK"
      print "------- [ok pressed] -------"
      if m.WarningDialog.visible = true
        m.WarningDialog.visible = "false"
        m.HeroScreen.setFocus(true)
        result = true
      else if m.DetailsScreen.videoPlayerVisible = true
	   m.stars.visible = "false"
	   m.stars.setFocus(false)
	 'else if m.DetailsScreen.videoPlayerVisible = false and m.DetailsScreen.visible = true
	  ' m.stars.visible = "true"
	  ' m.stars.setFocus(false)
	  ' result = true
	 'else if m.herobuttons.setFocus(true) and m.stars.visible = false
	 '  print "ABOUT WAS PRESSED"
	 '  'take to about screen
	 else if m.stars.setFocus(true) and m.stars.visible = true
	   if m.stars.focusBitmapUri="pkg:/images/Star_rating_0_of_5.png"
	     getStars = 0
		print getStars
	   else if m.stars.focusBitmapUri="pkg:/images/Star_rating_1_of_5.png"
	     getStars = 1
		print getStars
	   else if m.stars.focusBitmapUri="pkg:/images/Star_rating_2_of_5.png"
	     getStars = 2
		print getStars
	   else if m.stars.focusBitmapUri="pkg:/images/Star_rating_3_of_5.png"
	     getStars = 3
		print getStars
	   else if m.stars.focusBitmapUri="pkg:/images/Star_rating_4_of_5.png"
	     getStars = 4
		print getStars
	   else if m.stars.focusBitmapUri="pkg:/images/Star_rating_5_of_5.png"
	     getStars = 5
		print getStars
	 end if
    end if
    end if
 end if
  return result
end function

'///////////////////////////////////////////'
' Helper function convert AA to Node
Function ContentList2SimpleNode(contentList as Object, nodeType = "ContentNode" as String) as Object
  print "DetailsScreen.brs - [ContentList2SimpleNode]"
  result = createObject("roSGNode", nodeType)
  if result <> invalid
    for each itemAA in contentList
      item = createObject("roSGNode", nodeType)
	 item.setFields(itemAA)
	 result.appendChild(item)
    end for
  end if
  return result
End Function
