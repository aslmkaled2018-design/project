import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'MyGarden.dart';
import 'plant_inference_service.dart';
import 'disease_translations.dart';

class Botaipage extends StatefulWidget {
  const Botaipage({super.key});

  @override
  State<Botaipage> createState() => _BotaipageState();
}

class _BotaipageState extends State<Botaipage> {
  final ImagePicker picker = ImagePicker();
  final PlantInferenceService _inferenceService = PlantInferenceService();

  File? imagefile;
  bool showSaveButton = false;
  bool showTreatmentBox = false;
  bool isAnalyzing = false;
  String diseaseResult = "";
  String treatmentResult = "";

  @override
  void initState() {
    super.initState();
    _inferenceService.initModels(); // ← تحميل الموديلين عند فتح الصفحة
  }

  @override
  void dispose() {
    _inferenceService.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (image != null) {
      setState(() {
        imagefile = File(image.path);
        showSaveButton = false;
        showTreatmentBox = false;
        diseaseResult = "";
        treatmentResult = "";
      });
    }
  }

  // ── التحليل الحقيقي بالموديل ──
  Future<void> analyzeImage() async {
    if (imagefile == null) return;

    setState(() => isAnalyzing = true);

    final result = await _inferenceService.processImage(imagefile!);

    // مش ورقة نبات
    if (result.startsWith("INVALID_IMAGE:")) {
      setState(() {
        isAnalyzing = false;
        diseaseResult = result.replaceAll("INVALID_IMAGE: ", "");
        treatmentResult = "";
        showTreatmentBox = false;
        showSaveButton = false;
      });
      return;
    }

    // خطأ في الموديل
    if (result.startsWith("ERROR")) {
      setState(() {
        isAnalyzing = false;
        diseaseResult = "حصل خطأ في التحليل، حاول تاني";
        treatmentResult = "";
        showTreatmentBox = false;
        showSaveButton = false;
      });
      return;
    }

    // نتيجة صح - ترجم للعربي
    final info = diseaseInfo[result] ?? diseaseInfo['healthy']!;
    setState(() {
      isAnalyzing = false;
      diseaseResult = info['disease']!;
      treatmentResult = info['treatment']!;
      showTreatmentBox = true;
      showSaveButton = true;
    });
  }

  void showimagepickeroptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          color: isDark ? Colors.grey[850] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      iconSize: 20,
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color:
                        isDark
                            ? Colors.white70
                            : const Color.fromARGB(255, 56, 56, 56),
                  ),
                  title: Text(
                    "فتح الكاميرا",
                    style: TextStyle(
                      color:
                          isDark
                              ? Colors.white
                              : const Color.fromARGB(255, 89, 89, 89),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo,
                    color:
                        isDark
                            ? Colors.white70
                            : const Color.fromARGB(255, 60, 60, 60),
                  ),
                  title: Text(
                    "اختيار من المعرض",
                    style: TextStyle(
                      color:
                          isDark
                              ? Colors.white
                              : const Color.fromARGB(255, 80, 80, 80),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showGardenSheet(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final sheetColor = isDark ? Colors.grey[850]! : Colors.white;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.75,
              minChildSize: 0.4,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  color: sheetColor,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const Text(
                          "حديقتي 🌿",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 56, 114, 64),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'اختار النبتة اللي تضيف ليها نتيجة التحليل',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child:
                              myplants.isEmpty
                                  ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.eco_outlined,
                                        size: 60,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'مفيش نبتات في حديقتك لسه',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  )
                                  : GridView.builder(
                                    controller: scrollController,
                                    itemCount: myplants.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                          childAspectRatio: 0.85,
                                        ),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (diseaseResult.isNotEmpty) {
                                            setState(() {
                                              myplants[index].healthRecords.add(
                                                HealthRecord(
                                                  disease: diseaseResult,
                                                  treatment: treatmentResult,
                                                  date: DateTime.now(),
                                                  // healthy = false, غيره = true
                                                  hasDisease:
                                                      diseaseResult !=
                                                      diseaseInfo['healthy']!['disease'],
                                                ),
                                              );
                                              imagefile = null;
                                              showSaveButton = false;
                                              showTreatmentBox = false;
                                              diseaseResult = "";
                                              treatmentResult = "";
                                            });
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          child: Stack(
                                            children: [
                                              Image.file(
                                                File(myplants[index].image),
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                15,
                                                              ),
                                                          bottomRight:
                                                              Radius.circular(
                                                                15,
                                                              ),
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      myplants[index].name,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                56,
                                114,
                                64,
                              ),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text("إغلاق"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? Colors.grey[900]! : const Color.fromARGB(255, 236, 255, 237);
    final cardColor = isDark ? Colors.grey[850]! : Colors.white;
    final shadowColor =
        isDark ? Colors.black : const Color.fromARGB(255, 149, 234, 179);
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor =
        isDark ? Colors.grey[400]! : const Color.fromARGB(255, 78, 139, 88);
    const greenColor = Color.fromARGB(255, 56, 114, 64);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: greenColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "تحديد النبتة",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: bgColor,
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // ── تعليمات التصوير ──
          if (imagefile == null) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 8, bottom: 4),
              child: Text(
                'تعليمات التصوير',
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.end,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _tipRow(
                    'استخدم إضاءة جيدة (يفضل الإضاءة الطبيعية)',
                    textColor,
                  ),
                  _tipRow('ثبّت الكاميرا جيداً', textColor),
                  _tipRow('اقترب من النبتة', textColor),
                  _tipRow('ركّز على الجزء المصاب من الورقة', textColor),
                ],
              ),
            ),
          ],

          // ── مربع الصورة ──
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  color: shadowColor,
                  offset: const Offset(7, 5),
                ),
              ],
            ),
            padding: EdgeInsets.only(
              left: screenWidth * 0.08,
              right: screenWidth * 0.08,
              top: screenHeight * 0.04,
              bottom: screenHeight * 0.03,
            ),
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            child: Column(
              children: [
                DottedBorder(
                  color:
                      isDark
                          ? Colors.grey[600]!
                          : const Color.fromARGB(255, 201, 222, 203),
                  strokeWidth: 2,
                  borderType: BorderType.RRect,
                  dashPattern: const [8, 6],
                  radius: const Radius.circular(20),
                  child: Container(
                    width: double.infinity,
                    height: screenHeight * 0.25,
                    alignment: Alignment.center,
                    child:
                        imagefile == null
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload_file_rounded,
                                  size: screenWidth * 0.12,
                                  color: hintColor,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'اختار صورة ورقة النبتة',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.042,
                                    fontWeight: FontWeight.bold,
                                    color: greenColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'تأكد إن الصورة واضحة وعلى ورقة النبتة',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                imagefile!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // أزرار الصورة
                imagefile == null
                    ? ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: showimagepickeroptions,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('اختار صورة'),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenColor,
                            foregroundColor: Colors.white,
                          ),
                          // ← هنا بنستدعي الموديل الحقيقي
                          onPressed: isAnalyzing ? null : analyzeImage,
                          icon:
                              isAnalyzing
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(Icons.search),
                          label: Text(
                            isAnalyzing ? 'جاري التحليل...' : 'تحليل الصورة',
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton.icon(
                          onPressed:
                              () => setState(() {
                                imagefile = null;
                                showSaveButton = false;
                                showTreatmentBox = false;
                                diseaseResult = "";
                                treatmentResult = "";
                              }),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          label: const Text(
                            'حذف',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),

          // ── نتيجة التحليل ──
          if (diseaseResult.isNotEmpty)
            Container(
              padding: EdgeInsets.all(screenWidth * 0.05),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: shadowColor,
                    offset: const Offset(5, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'نتيجة التحليل',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: greenColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    diseaseResult,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: textColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

          // ── خطة العلاج ──
          if (showTreatmentBox && treatmentResult.isNotEmpty)
            Container(
              padding: EdgeInsets.all(screenWidth * 0.05),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: shadowColor,
                    offset: const Offset(5, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'خطة العلاج',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: greenColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    treatmentResult,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: screenWidth * 0.038,
                      color: textColor,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),

          // ── زر الحفظ في حديقتي ──
          if (showSaveButton)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed:
                      () => showGardenSheet(context, screenWidth, screenHeight),
                  icon: const Icon(Icons.save_alt),
                  label: const Text('حفظ في حديقتي'),
                ),
              ),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _tipRow(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(text, style: TextStyle(fontSize: 13, color: textColor)),
          const SizedBox(width: 6),
          const Icon(
            Icons.circle,
            size: 6,
            color: Color.fromARGB(255, 56, 114, 64),
          ),
        ],
      ),
    );
  }
}
