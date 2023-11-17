
import 'package:flutter/material.dart';

import '../../utils/constant.dart';

class DropDownMenu extends StatelessWidget {
  final  Function(int?) onChanged;
   DropDownMenu({Key? key,  required this.onChanged }) : super(key: key);

  final valueNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.brown),
            borderRadius: BorderRadius.circular(8),
      ),
      child: ValueListenableBuilder<int>(

        builder: (context, value, child) {
          return DropdownButton<int>(
            value: value,
            alignment: Alignment.center,
            elevation: 16,
           underline: Container(),
            onChanged: (int? value){
              onChanged(value);
              valueNotifier.value = value??0;
            },
            items: valueItems.asMap().entries.map<DropdownMenuItem<int>>(
                  (MapEntry<int, String> entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              },
            ).toList(),
          );
        }, valueListenable: valueNotifier,

      ),
    );
  }
}



/*
*
* DropdownButtonFormField2<int>(
      isExpanded: false,
      decoration: InputDecoration(
        // Add Horizontal padding using menuItemStyleData.padding so it matches
        // the menu padding when button's width is not specified.
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        // Add more decoration..
      ),
      hint: const Text(
        'Select Your Action Type',
        style: TextStyle(fontSize: 14),
      ),
      items: valueItems.asMap().entries.map<DropdownMenuItem<int>>(
            (MapEntry<int, String> entry) {
          return DropdownMenuItem<int>(
            value: entry.key,
            child: Text(entry.value),
          );
        },
      ).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select gender.';
        }
        return null;
      },
      onChanged: onChanged,
      onSaved: (value) {
       // selectedValue = value.toString();
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
* */



/*
DropdownButton<int>(
      value: 0,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(
          color: Colors.deepPurple
      ),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (int? value){
         Utils.showToastMessage("the ${valueItems[value?? 0]} index is ${value}");
      },
      items: valueItems.asMap().entries.map<DropdownMenuItem<int>>(
            (MapEntry<int, String> entry) {
          return DropdownMenuItem<int>(
            value: entry.key,
            child: Text(entry.value),
          );
        },
      ).toList(),
    );
*  */