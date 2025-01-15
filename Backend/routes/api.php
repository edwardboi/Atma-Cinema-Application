<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\FilmController;
use App\Http\Controllers\FnBController;
use App\Http\Controllers\HistoryController;
use App\Http\Controllers\JadwalController;
use App\Http\Controllers\PemesananController;
use App\Http\Controllers\ReviewController;
use App\Http\Controllers\StudioController;
use App\Http\Controllers\TiketController;
use App\Http\Controllers\WishlistController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\JamController;
use App\Http\Controllers\JamTayangController;
use PHPUnit\Framework\Attributes\Ticket;

Route::post('/register', [UserController::class, 'register']);
Route::post('/login', [UserController::class, 'login']);


Route::middleware('auth:api')->group(function () {

    Route::get('/user', [UserController::class, 'index']);
    Route::put('/user/update', [UserController::class, 'update']);
    Route::delete('/user/delete', [UserController::class, 'destroy']);
    Route::post('/user/updateFoto', [UserController::class, 'updateFoto']);
    Route::post('/logout', [UserController::class, 'logout']);

    
});

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::resource('film', FilmController::class);
Route::resource('fnb', FnbController::class);
Route::resource('history', HistoryController::class);
Route::resource('jadwal', JadwalController::class);
Route::resource('pemesanan', PemesananController::class);
Route::resource('review', ReviewController::class);
Route::resource('studio', StudioController::class);
Route::resource('tiket', TiketController::class);
Route::resource('wishlist', WishlistController::class);

Route::resource('jam', JamController::class);
Route::resource('jamTayang', JamTayangController::class);
Route::get('jamTayang/studio/{id}', [JamTayangController::class, 'findByStudioId']);

Route::get('/review/film/{id_film}', [ReviewController::class, 'getReviewsByFilm']);
Route::get('/review/user/{id_user}', [ReviewController::class, 'getReviewsByUser']);
Route::get('/review/tiket/{id}', [ReviewController::class, 'getReviewsByTicket']);

Route::get('jadwal/hari/ini', [JadwalController::class, 'jadwalHariIni']);

Route::get('tiket/user/show/{id}', [TiketController::class, 'showTiketByUser']);
Route::get('wishlist/user/{id}', [WishlistController::class, 'fetchWishlistByUser']);

Route::get('/pemesanan/kapasitas/{id_jadwal}/{id_studio}/{id_jamtayang}/{id_film}', [PemesananController::class, 'getSisaKapasitas']);

Route::get('/review/rata/{id_film}', [ReviewController::class, 'getAverageRating']);


