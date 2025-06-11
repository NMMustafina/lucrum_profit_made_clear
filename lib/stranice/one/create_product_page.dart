import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profit_made_clear_254_t/md/category/category_model.dart';
import 'package:profit_made_clear_254_t/md/product/product_category_model.dart';
import 'package:profit_made_clear_254_t/stranice/one/part_o_page.dart';

import '../../asf/app_button.dart';
import '../../asf/color_asf.dart';
import 'my_category_page.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({
    super.key,
    required this.categoryModel,
    this.isEdit = false,
    this.productCategoryModel,
  });

  final CategoryModel categoryModel;
  final bool isEdit;
  final ProductCategoryModel? productCategoryModel;

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  late final ValueNotifier<bool> hasChanges =
      ValueNotifier(nameController.text.isNotEmpty);

  bool asdf() {
    if (nameController.text.isNotEmpty) {
      hasChanges.value = true;
      return true;
    } else {
      hasChanges.value = false;
      return false;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _confirmDeleteImage() async {
    final confirm = await showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Delete photo?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              setState(() => _imageFile = null);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!hasChanges.value) return true;
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Leave the screen?'),
        content: const Text(
            'If you leave, any changes you have made will not be saved'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Leave'),
            onPressed: () => Navigator.pop(context, true),
          )
        ],
      ),
    );
    return result ?? false;
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _imageFile = File(widget.productCategoryModel!.im);
      nameController.text = widget.productCategoryModel!.naaame;
      descController.text = widget.productCategoryModel!.dessssss;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarApp(
          title: widget.isEdit ? 'Edit product' : 'Create product',
          leadingTap: () async {
            if (await _onWillPop()) Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo section
                Text('Add a photo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    )),
                SizedBox(height: 8.h),
                _imageFile == null
                    ? GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 150.w,
                          height: 150.w,
                          decoration: BoxDecoration(
                            color: ColorAsf.k252525,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset('assets/icons/pls.svg'),
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _imageFile!,
                              width: 150.w,
                              height: 150.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Buttons (in a row)
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Edit button
                                OutlinedButton.icon(
                                  onPressed: _pickImage,
                                  label: Row(
                                    children: [
                                      SvgPicture.asset('assets/icons/en.svg'),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Color(0xFF007AFF),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    side: BorderSide(color: Color(0xFF007AFF)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),

                                // Delete button
                                OutlinedButton.icon(
                                  onPressed: _confirmDeleteImage,
                                  label: Row(
                                    children: [
                                      SvgPicture.asset('assets/icons/de.svg'),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 12),
                                    side: BorderSide(color: Colors.red),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 16.h),
                // Form
                _buildTextField(
                    label: 'Product name ',
                    hint: "Enter product name",
                    controller: nameController,
                    required: true),
                SizedBox(height: 12.h),
                _buildTextField(
                  label: 'Description',
                  controller: descController,
                  hint: "Enter a description",
                  maxLine: 8,
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ValueListenableBuilder(
          valueListenable: hasChanges,
          builder: (context, value, child) {
            return AppButton(
              padding: EdgeInsets.symmetric(horizontal: 12),
              icon: 'assets/icons/dfdfd.svg',
              text: 'Save',
              onTap: () {
                if (hasChanges.value) {
                  if (widget.isEdit) {
                    CategoryModel s = widget.categoryModel;
                    final String id = widget.productCategoryModel?.id ?? "";
                    ProductCategoryModel bbb = ProductCategoryModel(
                      primeId: s.id,
                      id: id,
                      dessssss: descController.text,
                      im: _imageFile?.path ?? '',
                      naaame: nameController.text,
                      transactionModelList: widget.productCategoryModel?.transactionModelList ?? [],
                    );
                    List<ProductCategoryModel> f = s.listProduct;
                    // f.add(bbb);
                    for(int i =0;f.length>i;i++){
                      if (f[i].id== bbb.id) {
                        f[i] = bbb;
                        break;
                      }
                    }
                    AS.localCategory.put(
                        s.key,
                        CategoryModel(
                            id: s.id,
                            tit: s.tit,
                            des: s.des,
                            im: s.im,
                            listProduct: f));
                    Navigator.of(context).pop();
                  } else {
                    CategoryModel s = widget.categoryModel;
                    final String id = DateTime.now().toIso8601String();
                    ProductCategoryModel bbb = ProductCategoryModel(
                      primeId: s.id,
                      id: id,
                      dessssss: descController.text,
                      im: _imageFile?.path ?? '',
                      naaame: nameController.text,
                      transactionModelList: [],
                    );
                    var f = s.listProduct;
                    f.add(bbb);
                    AS.localCategory.put(
                        s.key,
                        CategoryModel(
                            id: s.id,
                            tit: s.tit,
                            des: s.des,
                            im: s.im,
                            listProduct: f));
                    Navigator.of(context).pop();
                  }
                }
              },
              colorAll: hasChanges.value,
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool required = false,
    int maxLine = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (required)
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: ColorAsf.b107CE0,
                ),
              )
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          onChanged: (value) {
            asdf();
          },
          controller: controller,
          maxLines: maxLine,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.blue,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: ColorAsf.k252525,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        )
      ],
    );
  }
}
