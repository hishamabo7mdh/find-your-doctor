import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/home/patientHome/presentation/view_model/home_cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void changeBottomNav(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}