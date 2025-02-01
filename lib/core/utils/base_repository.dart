import 'package:dartz/dartz.dart';
import 'package:adisyonapp/core/errors/failures.dart';

abstract class BaseRepository<T> {
  Future<Either<Failure, T>> get(String id);
  Future<Either<Failure, List<T>>> getAll();
  Future<Either<Failure, T>> create(T entity);
  Future<Either<Failure, T>> update(T entity);
  Future<Either<Failure, bool>> delete(String id);
}

abstract class BaseLocalRepository<T> {
  Future<Either<Failure, T>> get(String id);
  Future<Either<Failure, List<T>>> getAll();
  Future<Either<Failure, T>> save(T entity);
  Future<Either<Failure, bool>> delete(String id);
  Future<Either<Failure, bool>> clear();
}

abstract class BaseCacheRepository<T> {
  Future<Either<Failure, T?>> get(String key);
  Future<Either<Failure, bool>> set(String key, T value);
  Future<Either<Failure, bool>> remove(String key);
  Future<Either<Failure, bool>> clear();
} 