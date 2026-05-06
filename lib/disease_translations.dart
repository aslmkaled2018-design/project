// ترجمة نتايج الموديل لعربي + خطة العلاج

const Map<String, Map<String, String>> diseaseInfo = {
  'bacteria': {
    'disease':
        'مرض بكتيري\nالنبتة مصابة بعدوى بكتيرية تظهر على شكل بقع داكنة أو مناطق متعفنة.',
    'treatment':
        '• أزل الأجزاء المصابة فوراً\n• رش مبيد بكتيري (نحاسي) كل 7 أيام\n• تجنب الري الزائد\n• حسّن التهوية حول النبتة\n• عقّم الأدوات قبل وبعد الاستخدام',
    'plantType': 'Plant',
    'conditionName': 'Bacterial Infection',
    'detectedCategory': 'bacteria',
  },
  'fungi': {
    'disease':
        'مرض فطري\nالنبتة مصابة بعدوى فطرية تظهر على شكل بقع بيضاء أو رمادية أو سوداء.',
    'treatment':
        '• رش مبيد فطري مناسب كل 5-7 أيام\n• قلل الرطوبة حول النبتة\n• أزل الأوراق المصابة\n• تجنب رش الماء على الأوراق\n• حسّن التهوية',
    'plantType': 'Plant',
    'conditionName': 'Fungal Infection',
    'detectedCategory': 'fungi',
  },
  'healthy': {
    'disease': '✅ النبتة سليمة\nلا توجد أي علامات مرضية، نبتتك بصحة جيدة!',
    'treatment':
        '• استمر في الري المنتظم\n• تأكد من التسميد الدوري\n• حافظ على التهوية الجيدة\n• راقب النبتة بانتظام',
    'plantType': 'Plant',
    'conditionName': 'Healthy',
    'detectedCategory': 'healthy',
  },
  'pests': {
    'disease': 'إصابة بالآفات\nالنبتة مصابة بحشرات أو آفات تتغذى على أوراقها.',
    'treatment':
        '• رش مبيد حشري مناسب\n• استخدم الصابون الحشري كبديل طبيعي\n• أزل الحشرات يدوياً إن أمكن\n• عزل النبتة عن باقي النباتات\n• كرر الرش كل 5 أيام',
    'plantType': 'Plant',
    'conditionName': 'Pest Infestation',
    'detectedCategory': 'pests',
  },
  'virus': {
    'disease':
        'مرض فيروسي\nالنبتة مصابة بفيروس يظهر على شكل تشوه في الأوراق أو تغير في اللون.',
    'treatment':
        '• لا يوجد علاج مباشر للفيروسات\n• أزل النبتة المصابة لمنع انتشار العدوى\n• اقضِ على الحشرات الناقلة للفيروس\n• عقّم التربة والأدوات\n• استبدل النبتة بأخرى سليمة',
    'plantType': 'Plant',
    'conditionName': 'Viral Infection',
    'detectedCategory': 'virus',
  },
};
