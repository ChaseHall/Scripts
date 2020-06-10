; CTRL+Alt+V = Run
^!v::
Loop, 10
{
;send {Click}
Send {WheelDown}
sleep 100
;Send {WheelDown}
;Send {WheelDown}
;Send {WheelDown}
;Send {WheelDown}
;Send {WheelDown}
sleep 100
send {Click}
sleep 200
}
return