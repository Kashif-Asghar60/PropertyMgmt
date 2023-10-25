import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/constants.dart';

class CustomDropdownTextField<T> extends StatefulWidget {
  final String label;
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final Color backgroundColor;
  final double width;
  final bool? enabled;
final String? errorText;
  CustomDropdownTextField({
    this.enabled=true,
    this.errorText,
    required this.width,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.backgroundColor,
  });

  @override
  _CustomDropdownTextFieldState<T> createState() =>
      _CustomDropdownTextFieldState<T>();
}

class _CustomDropdownTextFieldState<T>
    extends State<CustomDropdownTextField<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final List<T> itemsWithAddItem = List.from(widget.items);
    itemsWithAddItem.add('Add Item' as T);

    return SizedBox(
      width: widget.width,
      height: Dimensions.buttonHeight * 1.2,
      child: InputDecorator(
        decoration: InputDecoration(
          errorText: widget.errorText,
          contentPadding:
          
              const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          labelStyle: TextStyle(fontSize: Dimensions.Txtfontsize),
          labelText: widget.label,
          fillColor: widget.backgroundColor,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff8A8282),
              width: .5,
            ),
          ),
        ),
        child: DropdownButton<T>(
          
          iconSize: Dimensions.iconSize,
          underline: const SizedBox(),
          isExpanded: true,
          value: selectedValue,
          onChanged: (newValue) {
            setState(() {
              selectedValue = newValue;
            });
            if (newValue == 'Add Item') {
              _showAddItemDialog(context);
            } else {
              widget.onChanged(newValue);
            }
          },
          items: itemsWithAddItem.map<DropdownMenuItem<T>>((T item) {
            return DropdownMenuItem<T>(
              enabled:widget.enabled! ,
              value: item,
              child: Text(
                item.toString(),
                style: TextStyle(fontSize: Dimensions.Txtfontsize / 1.2),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String newItem = ''; // Initialize with an empty string
        return AlertDialog(
          title: Text('Add New Item'),
          content: TextField(
            onChanged: (value) {
              newItem = value;
            },
            decoration: InputDecoration(labelText: 'New Item'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (newItem.isNotEmpty) {
                  setState(() {
                    widget.items.insert(widget.items.length - 1, newItem as T);
                  });
                  selectedValue = newItem as T;
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
