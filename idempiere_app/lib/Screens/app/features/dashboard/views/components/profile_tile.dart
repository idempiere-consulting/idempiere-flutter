part of dashboard;

// ignore: must_be_immutable
class _ProfilTile extends StatelessWidget {
  _ProfilTile(
      {required this.data,
      required this.onPressedNotification,
      required this.counter,
      Key? key})
      : super(key: key);

  final _Profile data;
  final Function() onPressedNotification;

  int counter;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: CircleAvatar(backgroundImage: data.photo),
      title: Text(
        data.name,
        style: TextStyle(fontSize: 14, color: kFontColorPallets[0]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        data.email,
        style: TextStyle(fontSize: 12, color: kFontColorPallets[2]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      /* trailing: IconButton(
        onPressed: onPressedNotification,
        icon: const Icon(EvaIcons.bellOutline),
        tooltip: "notification",
      ), */
      trailing: Stack(
        children: <Widget>[
          IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: onPressedNotification),
          Visibility(
            visible: counter != 0 ? true : false,
            child: Positioned(
              right: 11,
              top: 11,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: Text(
                  '$counter',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
