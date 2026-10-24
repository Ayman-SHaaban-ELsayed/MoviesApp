import 'package:dio/dio.dart';
import 'package:movies_app/api/model/api/api_constants.dart';
import 'package:movies_app/api/model/api/api_end_points.dart';
import 'package:movies_app/api/model/movie/movie.dart';
import 'package:movies_app/api/model/movie_details.dart';

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

      if (response.statusCode == 200 && response.data['status'] == 'ok') {
        List moviesJson = response.data['data']['movies'] ?? [];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception(
          response.data['status_message'] ?? 'Failed to load movies',
        );
      }
    } on DioException catch (error) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception("Timeout occurred while sending or receiving");
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode != null) {
            switch (statusCode) {
              case 400:
                throw Exception("Bad Request");
              case 401:
              case 403:
                throw Exception("Unauthorized");
              case 404:
                throw Exception("Not Found");
              case 409:
                throw Exception('Conflict');
              case 500:
                throw Exception("Internal Server Error");
            }
          }
          break;
        case DioExceptionType.cancel:
          break;
        case DioExceptionType.unknown:
          throw Exception("No Internet Connection");
        case DioExceptionType.badCertificate:
          throw Exception("Internal Server Error");
        case DioExceptionType.connectionError:
          throw Exception("Connection Error");
        default:
          throw Exception("Unknown Error");
      }
      throw Exception("Unknown Error");
    } catch (e) {
      rethrow;
    }
  }


  static Future<MovieDetails> getMovieDetails(int movieId) async {
    try {
      final response = await dio.get(
        ApiEndPoints.movieDetails,
        queryParameters: {
          'movie_id': movieId,
          'with_images': true,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'ok') {
        return MovieDetails.fromJson(response.data['data']['movie']);
      } else {
        throw Exception(response.data['status_message'] ?? 'Failed to load movie details');
      }
    } on DioException catch (error) {
      throw Exception("Error fetching details: ${error.message}");
    }
  }
}