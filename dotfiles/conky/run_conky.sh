sleep 5
num_monitors=$(xrandr | grep " connected" | wc -l)

if [ "$num_monitors" -gt 1 ]; then
    conky -c ~/.config/conky/conky_trending_xm.conf &
    conky -c ~/.config/conky/conky_new_xm.conf &
    conky -c ~/.config/conky/conky_upcoming_xm.conf &
else
    conky -c ~/.config/conky/conky_trending_1m.conf &
    conky -c ~/.config/conky/conky_new_1m.conf &
    conky -c ~/.config/conky/conky_upcoming_1m.conf &
fi