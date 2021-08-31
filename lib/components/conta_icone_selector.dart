import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContaIconeSelector extends StatefulWidget {
  String _selected;

  ContaIconeSelector(this._selected);

  String getSelected() {
    return _selected;
  }

  setSelected(String value) {
    _selected = value;
  }

  @override
  _ContaIconeSelectorState createState() => _ContaIconeSelectorState(_selected);
}

class _ContaIconeSelectorState extends State<ContaIconeSelector> {
  String _selected;

  _ContaIconeSelectorState(this._selected);

  String getSelected() {
    return _selected;
  }

  setSelected(String value) {
    setState(() {
      _selected = value;
      widget.setSelected(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 5,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          padding: EdgeInsets.all(10),
          children: [
            _makeIcone('carteira', this),
            _makeIcone('banrisul', this),
            _makeIcone('bb', this),
            _makeIcone('caixa', this),
            _makeIcone('itau', this),
            _makeIcone('mastercard', this),
            _makeIcone('nubank', this),
            _makeIcone('santander', this),
            _makeIcone('sicredi', this),
          ]
      ),
    );
  }
}

Widget _makeIcone(String id, _ContaIconeSelectorState state) {
  return Opacity(
    opacity: state.getSelected() == id ? 1 : 0.25,
    child: GestureDetector(
      child: SvgPicture.asset('logos/' + id + '.svg'),
      onTap: () {
        state.setSelected(id);
      }
    ),
  );
}