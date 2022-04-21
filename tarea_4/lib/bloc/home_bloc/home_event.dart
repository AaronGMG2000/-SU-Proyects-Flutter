part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {}

class SelectPage extends HomeEvent {
  final String page;
  SelectPage({
    required this.page,
  });
  @override
  List<Object?> get props => [page];
}
