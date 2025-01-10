part of dashboard;

class _Header extends StatelessWidget {
  final List<Types>? buttonList;

  final String? dropDownValue;
  final Function(String)? onChanged;

  _Header({Key? key, this.buttonList, this.dropDownValue, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buttonList == null
        ? Row(
            children: [
              const TodayText(),
              const SizedBox(width: kSpacing),
              Expanded(child: SearchField()),
            ],
          )
        : Row(
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Symbols.filter_alt),
                    Text(
                      "Quick Filters".tr,
                    )
                  ],
                ),
              ),
              Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: QuickFilterList(
                    buttonList: buttonList,
                    onQuickFilterSelected: (String value) {
                      print('AAA');
                      onChanged!(value);
                    },
                  )),
            ],
          );
  }
}

class QuickFilterList extends StatefulWidget {
  QuickFilterList({Key? key, this.buttonList, this.onQuickFilterSelected})
      : super(key: key);

  final List<Types>? buttonList;
  QuickFilterCallback? onQuickFilterSelected;

  @override
  State<QuickFilterList> createState() => _QuickFilterListState();
}

class _QuickFilterListState extends State<QuickFilterList> {
  late List<Types> dropDownList;
  String quickFilterDropdownValue = "0";
  @override
  void initState() {
    super.initState();
    dropDownList = widget.buttonList!;
    quickFilterDropdownValue = "0";
  }

  @override
  Widget build(BuildContext context) {
    //String locale = Localizations.localeOf(context).languageCode;
    return Container(
      margin: EdgeInsets.only(left: 10),
      //constraints: const BoxConstraints(maxWidth: 300),
      child: InputDecorator(
        decoration: const InputDecoration(
          //filled: true,
          border: OutlineInputBorder(
              /* borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none, */
              ),
          prefixIcon: Icon(EvaIcons.list),
          //hintText: "search..",
          isDense: true,
          //fillColor: Theme.of(context).cardColor,
        ),
        child: DropdownButton(
          isDense: true,
          underline: const SizedBox(),
          hint: Text("Select a Filter".tr),
          value: quickFilterDropdownValue,
          isExpanded: true,
          elevation: 16,
          onChanged: (newValue) {
            //print(dropdownValue);
            setState(() {
              quickFilterDropdownValue = newValue! as String;
            });

            widget.onQuickFilterSelected!(quickFilterDropdownValue);
          },
          items: dropDownList.map((list) {
            return DropdownMenuItem<String>(
              value: list.id,
              child: Text(
                list.name.toString(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

typedef QuickFilterCallback = void Function(String value);
