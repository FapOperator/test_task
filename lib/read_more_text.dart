import 'package:flutter/material.dart';

class ReadMoreText extends StatefulWidget {
  const ReadMoreText(
    this.data, {
    Key? key,
    this.trimCollapsedText = ' ...больше',
    this.colorClickableText,
    required this.trimLines,
  }) : super(key: key);

  final String data;
  final String trimCollapsedText;
  final Color? colorClickableText;
  final int trimLines;

  @override
  ReadMoreTextState createState() => ReadMoreTextState();
}

const String _kEllipsis = '\u2026';

class ReadMoreTextState extends State<ReadMoreText> {
  @override
  Widget build(BuildContext context) {
    //передача текста и назначение стилей плашке "больше"
    TextSpan link = TextSpan(
      text: widget.trimCollapsedText,
      style: const TextStyle(color: Colors.red),
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        // Создание текста
        final text = TextSpan(
          text: widget.data,
        );

        // размеры кнопки больше
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.ltr,
          maxLines: widget.trimLines,
          ellipsis: _kEllipsis,
        );
        // указание ширины текста
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        //вычисление размера плашки больше
        final linkSize = textPainter.size;

        // размеры текста
        textPainter.text = text;
        // указание ширины текста
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        //вычисление размера плашки больше
        final textSize = textPainter.size;

        // Получение последнего индекса строки
        int endIndex;

        if (linkSize.width < maxWidth) {
          final pos = textPainter.getPositionForOffset(Offset(
            textSize.width - linkSize.width,
            textSize.height,
          ));
          endIndex = textPainter.getOffsetBefore(pos.offset)!;
        } else {
          var pos = textPainter.getPositionForOffset(
            textSize.bottomLeft(Offset.zero),
          );
          endIndex = pos.offset;
        }

        TextSpan textSpan;
        // если есть переполнение добавляется плашка "больше"
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            style: const TextStyle(color: Colors.black),
            text: widget.data.substring(0, endIndex),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            style: const TextStyle(color: Colors.black),
            text: widget.data,
          );
        }
        //отрисовка виджета
        return RichText(
          textDirection: TextDirection.ltr,
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );

    return result;
  }
}
