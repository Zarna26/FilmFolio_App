import 'package:filmfolio/ui/widgets/video_input.dart';
import 'package:flutter/material.dart';
import '../../models/award.dart';
import '../../models/crew.dart';
import '../../models/movie.dart';
import '../../controllers/award_controller.dart';
import '../../controllers/crew_controller.dart';
import '../widgets/award_section.dart';
import '../widgets/basic_info_fields.dart';
import '../widgets/category_section.dart';
import '../widgets/crew_section.dart';
import '../widgets/duration_field.dart';
import '../widgets/photo_inputs_section.dart';
import '../widgets/release_date_picker.dart';
import '../widgets/storyline_language.dart';

class AddMoviePage extends StatefulWidget {
  final Function(Movie) onMovieAdded;

  const AddMoviePage({Key? key, required this.onMovieAdded}) : super(key: key);

  @override
  _AddMoviePageState createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  final CrewController _crewController = CrewController();
  final AwardController _awardController = AwardController();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _directorController = TextEditingController();
  final _storylineController = TextEditingController();
  final _languageController = TextEditingController();
  final _durationController = TextEditingController();

  DateTime? _releaseDate;
  bool _isMovie = false;
  List<String> _selectedCrew = [];
  List<String> _selectedCategories = [];
  List<Award> _selectedAwards = [];
  List<String> _photos = [];
  String? _trailerUrl;

  final List<String> _allCategories = [
    "Anime",
    "Horror",
    "Romantic",
    "Science-fiction",
    "Action",
    "Comedy",
    "Documentary",
    "Drama",
    "Fantasy",
    "Mystery",
    "Thriller",
  ];
  List<Award>? _allAwards;
  List<Crew> _selectedCrewList = [];
  List<Crew> crewList = [];
  List<Award> awardList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    crewList = await _crewController.getAllCrew();
    awardList = await _awardController.getAllAwards();

    setState(() {
      _allAwards = awardList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_allAwards == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Movie/Show'),iconTheme: IconThemeData(color: Colors.white), // Set back arrow color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicInfoFields(
                nameController: _nameController,
                directorController: _directorController,
                isMovie: _isMovie,
                onIsMovieChanged: (value) => setState(() => _isMovie = value),
              ),
              SizedBox(width: 12,),
              PhotoSection(
                photos: _photos,
                showname: _nameController.text,
                onPhotosChanged: (newPhotos) =>
                    setState(() => _photos = newPhotos),
              ),
              SizedBox(width: 12,),
              CategorySection(
                allCategories: _allCategories,
                selectedCategories: _selectedCategories,
                onCategorySelected: (category, selected) {
                  setState(() {
                    if (selected) {
                      _selectedCategories.add(category);
                    } else {
                      _selectedCategories.remove(category);
                    }
                  });
                },
              ),
              SizedBox(width: 12,),
              StorylineAndLanguageFields(
                storylineController: _storylineController,
                languageController: _languageController,
              ),
              SizedBox(width: 12,),
              ReleaseDatePicker(
                releaseDate: _releaseDate,
                onDateSelected: (date) => setState(() => _releaseDate = date),
              ),
              SizedBox(width: 12,),
              DurationField(controller: _durationController),
              SizedBox(width: 12,),
              CrewSection(
                selectedCrew: _selectedCrew,
                crewList: crewList,
                onCrewSelected: (member, selected) {
                  setState(() {
                    if (selected) {
                      _selectedCrew.add(member);
                      Crew? selectedCrewMember =
                      crewList.firstWhere((c) => c.name == member);
                      if (selectedCrewMember != null) {
                        _selectedCrewList.add(selectedCrewMember);
                      }
                    } else {
                      _selectedCrew.remove(member);
                    }
                  });
                },
              ),
              SizedBox(width: 12,),
              AwardsSection(
                allAwards: _allAwards!,
                selectedAwards: _selectedAwards,
                onAwardSelected: (award, selected) {
                  setState(() {
                    if (selected) {
                      _selectedAwards.add(award);
                    } else {
                      _selectedAwards.remove(award);
                    }
                  });
                },
              ),
              SizedBox(width: 12,),
              VideoInput(showname: _nameController.text,onVideoUploaded: (url) => _trailerUrl = url),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Movie/Show'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newMovie = Movie(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        director: _directorController.text,
        rating: 0.0,
        popularity: 0,
        isMovie: _isMovie,
        thumbnailUrl: _photos.isNotEmpty ? _photos[0] : '',
        trailer: _trailerUrl ?? '',
        photos: _photos,
        categories: _selectedCategories,
        storyline: _storylineController.text,
        language: _languageController.text,
        duration: int.tryParse(_durationController.text) ?? 0,
        releaseDate: _releaseDate!,
        crew: _selectedCrewList,
        awards: _selectedAwards,
      );

      widget.onMovieAdded(newMovie);
      Navigator.of(context).pop();
    }
  }
}
