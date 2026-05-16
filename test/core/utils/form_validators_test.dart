import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/utils/validators.dart';

void main() {
  group('FormValidators', () {
    group('required', () {
      test('null 值返回错误消息', () {
        final validator = FormValidators.required();
        expect(validator(null), equals('此字段为必填项'));
      });

      test('空字符串返回错误消息', () {
        final validator = FormValidators.required();
        expect(validator(''), equals('此字段为必填项'));
      });

      test('仅空白字符返回错误消息', () {
        final validator = FormValidators.required();
        expect(validator('   '), equals('此字段为必填项'));
      });

      test('有效值返回 null', () {
        final validator = FormValidators.required();
        expect(validator('hello'), isNull);
      });

      test('自定义错误消息', () {
        final validator = FormValidators.required('请填写此字段');
        expect(validator(''), equals('请填写此字段'));
      });
    });

    group('requiredSelection', () {
      test('null 值返回错误消息', () {
        final validator = FormValidators.requiredSelection<String>();
        expect(validator(null), equals('请选择一项'));
      });

      test('非 null 值返回 null', () {
        final validator = FormValidators.requiredSelection<String>();
        expect(validator('selected'), isNull);
      });

      test('空字符串视为有效（非 null）', () {
        final validator = FormValidators.requiredSelection<String>();
        expect(validator(''), isNull);
      });
    });

    group('minLength', () {
      test('值过短返回错误消息', () {
        final validator = FormValidators.minLength(5);
        expect(validator('abc'), equals('至少需要 5 个字符'));
      });

      test('值正好等于最小长度返回 null', () {
        final validator = FormValidators.minLength(5);
        expect(validator('abcde'), isNull);
      });

      test('值超过最小长度返回 null', () {
        final validator = FormValidators.minLength(5);
        expect(validator('abcdef'), isNull);
      });

      test('空值返回 null（不强制非空）', () {
        final validator = FormValidators.minLength(5);
        expect(validator(''), isNull);
        expect(validator(null), isNull);
      });

      test('自定义错误消息', () {
        final validator = FormValidators.minLength(5, '长度不足');
        expect(validator('abc'), equals('长度不足'));
      });
    });

    group('maxLength', () {
      test('值过长返回错误消息', () {
        final validator = FormValidators.maxLength(5);
        expect(validator('abcdef'), equals('最多允许 5 个字符'));
      });

      test('值正好等于最大长度返回 null', () {
        final validator = FormValidators.maxLength(5);
        expect(validator('abcde'), isNull);
      });

      test('值短于最大长度返回 null', () {
        final validator = FormValidators.maxLength(5);
        expect(validator('abc'), isNull);
      });

      test('空值返回 null', () {
        final validator = FormValidators.maxLength(5);
        expect(validator(''), isNull);
        expect(validator(null), isNull);
      });
    });

    group('lengthRange', () {
      test('值过短返回错误消息', () {
        final validator = FormValidators.lengthRange(3, 5);
        expect(validator('ab'), equals('长度需在 3-5 个字符之间'));
      });

      test('值过长返回错误消息', () {
        final validator = FormValidators.lengthRange(3, 5);
        expect(validator('abcdef'), equals('长度需在 3-5 个字符之间'));
      });

      test('值在范围内返回 null', () {
        final validator = FormValidators.lengthRange(3, 5);
        expect(validator('abc'), isNull);
        expect(validator('abcd'), isNull);
        expect(validator('abcde'), isNull);
      });

      test('空值返回 null', () {
        final validator = FormValidators.lengthRange(3, 5);
        expect(validator(''), isNull);
        expect(validator(null), isNull);
      });
    });

    group('pattern', () {
      test('值不匹配正则返回错误消息', () {
        final validator = FormValidators.pattern(RegExp(r'^\d+$'));
        expect(validator('abc'), equals('格式不正确'));
      });

      test('值匹配正则返回 null', () {
        final validator = FormValidators.pattern(RegExp(r'^\d+$'));
        expect(validator('123'), isNull);
      });

      test('空值返回 null', () {
        final validator = FormValidators.pattern(RegExp(r'^\d+$'));
        expect(validator(''), isNull);
        expect(validator(null), isNull);
      });

      test('自定义错误消息', () {
        final validator = FormValidators.pattern(RegExp(r'^\d+$'), '请输入数字');
        expect(validator('abc'), equals('请输入数字'));
      });
    });

    group('email', () {
      test('无效邮箱返回错误消息', () {
        final validator = FormValidators.email();
        expect(validator('invalid'), equals('请输入正确的邮箱地址'));
        expect(validator('test@'), equals('请输入正确的邮箱地址'));
        expect(validator('@test.com'), equals('请输入正确的邮箱地址'));
      });

      test('有效邮箱返回 null', () {
        final validator = FormValidators.email();
        expect(validator('test@example.com'), isNull);
        expect(validator('user.name@domain.co'), isNull);
        expect(validator('user-name@sub.domain.com'), isNull);
      });

      test('空值返回 null', () {
        final validator = FormValidators.email();
        expect(validator(''), isNull);
        expect(validator(null), isNull);
      });

      test('带空白字符的邮箱先 trim 再验证', () {
        final validator = FormValidators.email();
        expect(validator('  test@example.com  '), isNull);
      });
    });

    group('phone', () {
      test('无效手机号返回错误消息', () {
        final validator = FormValidators.phone();
        expect(validator('1234567890'), equals('请输入正确的手机号码')); // 少于11位
        expect(validator('123456789012'), equals('请输入正确的手机号码')); // 多于11位
        expect(validator('02312345678'), equals('请输入正确的手机号码')); // 以0开头
        expect(validator('12345678901x'), equals('请输入正确的手机号码')); // 含字母
      });

      test('有效手机号返回 null', () {
        final validator = FormValidators.phone();
        expect(validator('13812345678'), isNull);
        expect(validator('15912345678'), isNull);
        expect(validator('18812345678'), isNull);
        expect(validator('19912345678'), isNull);
      });

      test('空值返回 null', () {
        final validator = FormValidators.phone();
        expect(validator(''), isNull);
        expect(validator(null), isNull);
      });
    });

    group('sameAs', () {
      test('值匹配返回 null', () {
        final validator = FormValidators.sameAs(() => 'password');
        expect(validator('password'), isNull);
      });

      test('值不匹配返回错误消息', () {
        final validator = FormValidators.sameAs(() => 'password');
        expect(validator('wrong'), equals('输入内容不一致'));
      });

      test('trim 选项默认为 true', () {
        final validator = FormValidators.sameAs(() => 'password');
        expect(validator('  password  '), isNull);
      });

      test('trim 为 false 时不 trim 比较', () {
        final validator = FormValidators.sameAs(() => 'password', trim: false);
        expect(validator('password'), isNull);
        expect(validator('  password  '), equals('输入内容不一致'));
      });

      test('自定义错误消息', () {
        final validator = FormValidators.sameAs(() => 'password', message: '密码不一致');
        expect(validator('wrong'), equals('密码不一致'));
      });
    });

    group('compose', () {
      test('所有验证器通过返回 null', () {
        final validator = FormValidators.compose<String>([
          FormValidators.required(),
          FormValidators.minLength(3),
          FormValidators.maxLength(10),
        ]);
        expect(validator('hello'), isNull);
      });

      test('首个失败验证器返回其错误消息', () {
        final validator = FormValidators.compose<String>([
          FormValidators.required(),
          FormValidators.minLength(10),
        ]);
        expect(validator('hi'), equals('至少需要 10 个字符'));
      });

      test('空值由 required 验证器处理', () {
        final validator = FormValidators.compose<String>([
          FormValidators.required(),
          FormValidators.minLength(3),
        ]);
        expect(validator(''), equals('此字段为必填项'));
        expect(validator(null), equals('此字段为必填项'));
      });

      test('空迭代器返回 null', () {
        final validator = FormValidators.compose<String>([]);
        expect(validator('anything'), isNull);
      });
    });
  });
}
