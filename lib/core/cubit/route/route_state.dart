part of 'route_cubit.dart';

class RouteState {}

class RouteInitial extends RouteState {}

class RouteLoaded extends RouteState {}

class RouteError extends RouteState {
  final String message;

  RouteError(this.message);
}

class ClearRouteSuccess extends RouteState {}
