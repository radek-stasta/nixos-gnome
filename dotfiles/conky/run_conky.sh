sleep 5
primary_monitor=$(xrandr | grep " primary ")
if [[ "$primary_monitor" == *'eDP-1'* ]]; then
    conky -c ~/.config/conky/conky_trending_1m.conf &
    conky -c ~/.config/conky/conky_new_1m.conf &
    conky -c ~/.config/conky/conky_new_trending_1m.conf &
    conky -c ~/.config/conky/conky_upcoming_1m.conf &
else
    conky -c ~/.config/conky/conky_trending_xm.conf &
    conky -c ~/.config/conky/conky_new_xm.conf &
    conky -c ~/.config/conky/conky_new_trending_xm.conf &
    conky -c ~/.config/conky/conky_upcoming_xm.conf &
fi