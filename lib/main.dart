import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:test_task/common/list_string.dart';
import 'package:test_task/read_more_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    String list = listString.join(", ");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          OverflowDetectorText(
            child: Text(
              list,
            ),
          ),
        ],
      ),
    );
  }
}

class OverflowDetectorText extends StatelessWidget {
  final Text child;

  const OverflowDetectorText({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //временная вспомогательная переменная для текста
    List<String> supportTextParams = [];
    // отформатированный в конечный результат текст
    String mainText = '';
    // число строк при переполнении
    int? linesCountCollapse;
    //дефолтное значение числа строк текста без переполнения
    int linesCountFullText = 2;

    //вычисление размера body экрана
    double bodyHeight = (MediaQuery.of(context).size.height) -
        (Scaffold.of(context).appBarMaxHeight!) -
        MediaQuery.of(context).padding.top;

    return LayoutBuilder(
      builder: (context, constrains) {
        // цикл нужен для того чтоб словить слово после которого происходит переполнение
        for (int i = 0; i < listString.length; i++) {
          supportTextParams.add(listString[i]);
          mainText = supportTextParams.join(", ");
          // позволяет узнать высоту текста при каждой итерации цикла
          TextPainter tp = TextPainter(
            maxLines: child.maxLines,
            textAlign: child.textAlign ?? TextAlign.start,
            textDirection: child.textDirection ?? TextDirection.ltr,
            text: child.textSpan ??
                TextSpan(
                  text: mainText,
                  style: child.style,
                ),
          );
          // указание ширины текста
          tp.layout(maxWidth: constrains.maxWidth);
          //вычисление максимальное возможного количества строк на данной итерации, преобразование высот, в понятное число для maxLines
          linesCountFullText = (bodyHeight / tp.preferredLineHeight).ceil();
          //если высота текста превышает высоту body, то true
          if (tp.size.height > bodyHeight) {
            linesCountCollapse =
                (tp.size.height / tp.preferredLineHeight).ceil() - 1;
            break;
          }
        }
        //отрисовка конечного текста на экране
        return Column(
          children: [
            ReadMoreText(
              mainText,
              trimLines: linesCountCollapse ?? linesCountFullText,
              trimCollapsedText:
                  " + ${(listString.length - supportTextParams.length).toString()} больше",
            ),
          ],
        );
      },
    );
  }
}
