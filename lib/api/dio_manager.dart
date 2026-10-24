import 'package:dio/dio.dart';
import 'package:movies_app/api/model/api/api_constants.dart';
import 'package:movies_app/api/model/api/api_end_points.dart';
import 'package:movies_app/api/model/movie/movie.dart';

import 'model/movie_details.dart';

class DioManager {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  static Future<List<Movie>> getMovies({
    String? genre,
    int limit = 10,
    String? sortBy,
  }) async {
    try {
      final response = await dio.get(
        ApiEndPoints.listMovies,
        queryParameters: {
          'limit': limit,
          if (genre != null) 'genre': genre,
          if (sortBy != null) 'sort_by': sortBy,
        },
      );

      if (response.statusCode == 200 &&
          response.data['status'] == 'ok') {
        final List moviesJson =
            response.data['data']['movies'] ?? [];

        return moviesJson
            .map((json) => Movie.fromJson(json))
            .toList();
      } else {
        throw Exception(
          response.data['status_message'] ??
              'Failed to load movies',
        );
      }
    } on DioException catch (error) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        throw Exception(
          'Timeout occurred while sending or receiving',
        );

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;

          switch (statusCode) {
            case 400:
              throw Exception('Bad Request');
            case 401:
            case 403:
              throw Exception('Unauthorized');
            case 404:
              throw Exception('Not Found');
            case 409:
              throw Exception('Conflict');
            case 500:
              throw Exception('Internal Server Error');
          }
          throw Exception('Unknown Error');

        case DioExceptionType.cancel:
          throw Exception('Request cancelled');

        case DioExceptionType.unknown:
          throw Exception('No Internet Connection');

        case DioExceptionType.badCertificate:
          throw Exception('Bad Certificate');

        case DioExceptionType.connectionError:
          throw Exception('Connection Error');

        default:
          throw Exception('Unknown Error');
      }
    }
  }

  static Future<MovieDetails> getMovieDetails(int movieId,) async {
    try {
      final response = await dio.get(
        ApiEndPoints.movieDetails,
        queryParameters: {
          'movie_id': movieId,
        },
      );

      if (response.statusCode == 200 &&
          response.data['status'] == 'ok') {
        return MovieDetails.fromJson(
          response.data['data']['movie'],
        );
      } else {
        throw Exception(
          response.data['status_message'] ??
              'Failed to load movie details',
        );
      }
    } on DioException catch (error) {
      throw Exception(
        'Error fetching details: ${error.message}',
      );
    }
  }

  static Future<List<Movie>> getSimilarMovies(int movieId,) async {
    try {
      final response = await dio.get(
        ApiEndPoints.similarMovies,
        queryParameters: {
          'movie_id': movieId,
        },
      );

      if (response.statusCode == 200 &&
          response.data['status'] == 'ok') {
        final data = response.data['data'];

        final List moviesJson = data['movies'] ?? [];

        return moviesJson
            .map((json) => Movie.fromJson(json))
            .toList();
      } else {
        throw Exception(
          response.data['status_message'] ??
              'Failed to load similar movies',
        );
      }
    } on DioException catch (error) {
      throw Exception(
        'Error fetching similar movies: ${error.message}',
      );
    }
  }
}