i=$1
while (($i > 0))
	do
	gnome-terminal -x java Client
	let i--
done
