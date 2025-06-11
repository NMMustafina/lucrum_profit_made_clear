import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:profit_made_clear_254_t/stranice/one/part_o_page.dart';

import '../../asf/app_button.dart';
import '../../md/category/category_model.dart';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({
    super.key,
    this.isEdit = false,
    this.categoryModel,
  });

  final bool isEdit;
  final CategoryModel? categoryModel;

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  // final loca = GetIt.I.get<Box<CategoryModel>>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  String? selectedIcon;
  final List<String> iconPaths = [
    //1
    'assets/icons/wineglass.svg',
    //2
    'assets/icons/sofa.svg',
    //3
    'assets/icons/dgf.svg',
    //4
    'assets/icons/home.svg',
    //5
    'assets/icons/dumbbell_large.svg',
    //6
    'assets/icons/donut_bitten.svg',
    //7
    'assets/icons/transmission.svg',
    //8
    'assets/icons/cosmetic.svg',
    //9
    'assets/icons/h.svg',
    //10
    'assets/icons/t_shirt.svg',
    //11
    'assets/icons/ihone.svg',
    //12
    'assets/icons/ht.svg',
  ];

  @override
  void initState() {
    if (widget.isEdit) {
      nameController.text = widget.categoryModel!.tit;
      descController.text = widget.categoryModel!.des;
      selectedIcon = widget.categoryModel!.im;
      nameController.addListener(
        () {
          isEditasd();
        },
      );
      descController.addListener(
        () {
          isEditasd();
        },
      );
    }
    super.initState();
  }

  bool isEditasd() {
    if (widget.categoryModel?.tit != nameController.text ||
        widget.categoryModel?.des != descController.text ||
        widget.categoryModel?.im != selectedIcon) {
      setState(() {});
      return true;
    } else {
      setState(() {});
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () async {
            if (widget.isEdit && isEditasd()) {
              print('object');
              bool? a = await showLeaveConfirmationDialog(context);
              if (a ?? false) {
                Navigator.of(context).pop();
              }
            } else if (widget.categoryModel != null) {
              Navigator.of(context).pop();
            }
            if (!widget.isEdit) {
              bool a = await showLeaveConfirmationDialog(context) ?? false;
              if (a) {
                Navigator.of(context).pop();
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset('assets/icons/arrow_left.svg'),
          ),
        ),
        title: Text(
          widget.isEdit ? "Edit category" : 'Create category',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            CategoryForm(
              descController: descController,
              nameController: nameController,
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Text(
                'Select the icon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 8),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: iconPaths.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final path = iconPaths[index];
                final isSelected = selectedIcon == path;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedIcon = null; // снять выбор
                      } else {
                        selectedIcon = path;
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: Colors.blue, width: 2)
                          : Border.all(color: Colors.transparent),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        path,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                );
              },
            ),
            Spacer(),
            AppButton(
              icon: 'assets/icons/dfdfd.svg',
              text: "Save",
              colorAll: isEditasd() ? true : false,
              onTap: () {
                if (nameController.text.isNotEmpty) {
                  final String key = widget.isEdit
                      ? (widget.categoryModel?.id ?? '')
                      : DateTime.now().toString();
                  AS.localCategory.put(
                      key,
                      CategoryModel(
                          id: key,
                          tit: nameController.text,
                          des: descController.text,
                          im: selectedIcon ?? "assets/icons/gggg.svg",
                          listProduct: widget.isEdit
                              ? (widget.categoryModel?.listProduct ?? [])
                              : []));
                  Navigator.of(context).pop();
                }
              },
            ),
            SizedBox(height: 24.h)
          ],
        ),
      ),
    );
  }
}

class CategoryForm extends StatefulWidget {
  const CategoryForm({
    super.key,
    required this.nameController,
    required this.descController,
  });

  final TextEditingController nameController;

  final TextEditingController descController;

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final int maxLength = 15;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name of category label
        Row(
          children: [
            const Text(
              'Name of category',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '•',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Name input
        TextField(
          controller: widget.nameController,
          maxLength: maxLength,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.blue,
          decoration: InputDecoration(
            hintText: 'Enter a category name',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            counterText: '',
            suffix: Text(
                '${maxLength - widget.nameController.text.length}/$maxLength'),
            counterStyle: const TextStyle(color: Colors.white),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        SizedBox(height: 16.h),

        // Description label
        const Text(
          'Description',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),

        // Description input
        TextField(
          controller: widget.descController,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.blue,
          decoration: InputDecoration(
            hintText: 'Enter a description',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
