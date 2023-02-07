//https://school.programmers.co.kr/learn/courses/30/lessons/155652?language=kotlin
import 'dart:io';


void main() {
  var input = stdin.readLineSync()!.trim();
  var values = input.split(" ");

  var s = values[0];
  var skip = values[1];
  var index = int.parse(values[2]);

  var asc_s = new List.empty(growable: true);
  var l_skip = new List<bool>.filled(26, false);

  for (var i = 0; i < skip.length; i++) {
    l_skip[skip[i].codeUnitAt(0) - 97] = true;
  }

  for (var i = 0; i < s.length; i++) {
    asc_s.insert(i, s[i].codeUnitAt(0));
    var result_plus = 0;
    for (var j = 1; j <= index; j++) {
      if (l_skip[asc_s[i] - 97 + j] == true) result_plus++;
    }
    asc_s[i] = asc_s[i] + index + result_plus;
    if (asc_s[i] > 122) asc_s[i] -= 26;
  }

  list_print(asc_s);
}

list_print(list) {
  for (var i = 0; i < list.length; i++)
    stdout.write(String.fromCharCode(list[i]));
}
