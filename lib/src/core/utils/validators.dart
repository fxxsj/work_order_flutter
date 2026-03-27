import 'package:flutter/widgets.dart';
import 'package:work_order_app/src/core/utils/extensions/string_extensions.dart';

class FormValidators {
  const FormValidators._();

  static FormFieldValidator<T> compose<T>(
    Iterable<FormFieldValidator<T>> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null && result.isNotEmpty) {
          return result;
        }
      }
      return null;
    };
  }

  static FormFieldValidator<String> required([String? message]) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? '此字段为必填项';
      }
      return null;
    };
  }

  static FormFieldValidator<T> requiredSelection<T>([String? message]) {
    return (value) {
      if (value == null) {
        return message ?? '请选择一项';
      }
      return null;
    };
  }

  static FormFieldValidator<String> minLength(int min, [String? message]) {
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) {
        return null;
      }
      if (text.length < min) {
        return message ?? '至少需要 $min 个字符';
      }
      return null;
    };
  }

  static FormFieldValidator<String> maxLength(int max, [String? message]) {
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) {
        return null;
      }
      if (text.length > max) {
        return message ?? '最多允许 $max 个字符';
      }
      return null;
    };
  }

  static FormFieldValidator<String> lengthRange(
    int min,
    int max, [
    String? message,
  ]) {
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) {
        return null;
      }
      if (text.length < min || text.length > max) {
        return message ?? '长度需在 $min-$max 个字符之间';
      }
      return null;
    };
  }

  static FormFieldValidator<String> pattern(
    RegExp pattern, [
    String? message,
  ]) {
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) {
        return null;
      }
      if (!pattern.hasMatch(text)) {
        return message ?? '格式不正确';
      }
      return null;
    };
  }

  static FormFieldValidator<String> email([String? message]) {
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) {
        return null;
      }
      if (!text.isValidEmail) {
        return message ?? '请输入正确的邮箱地址';
      }
      return null;
    };
  }

  static FormFieldValidator<String> phone([String? message]) {
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) {
        return null;
      }
      if (!text.isValidPhone) {
        return message ?? '请输入正确的手机号码';
      }
      return null;
    };
  }

  static FormFieldValidator<String> sameAs(
    String Function() otherValue, {
    String? message,
    bool trim = true,
  }) {
    return (value) {
      final current = trim ? (value?.trim() ?? '') : (value ?? '');
      final target = trim ? otherValue().trim() : otherValue();
      if (current != target) {
        return message ?? '输入内容不一致';
      }
      return null;
    };
  }
}
