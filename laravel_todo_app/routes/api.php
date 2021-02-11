<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\UserController;
use App\Http\Controllers\TodoController;


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/


Route::get('/greeting', function () {
    return 'Hello World';
});



//routes for todos
Route::get('/todos', [TodoController::class, 'show']);
Route::post('/todos', [TodoController::class, 'create']);
Route::put('/todos/{id}', [TodoController::class, 'update']);

Route::delete('/todos/{id}', [TodoController::class, 'delete']);

// Route::get('/todos', [TodoController::class, 'show']);


Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

