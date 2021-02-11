<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use DB;
use App\Todo;


class TodoController extends Controller
{
    public function show(){
        return DB::table('todos')->get()->all();
    }

    public function create(Request $request){
        $validatedData = $request->validate([
            'title' => 'required|max:255',
        ]);
        $todo = new todo();
        $todo->title = $request->input('title');
        $todo->userId = $request->input('userId');
        try{
            $todo->save();

            return DB::table('todos')->get()->all();
        }
        catch(Exception $e){
            return response()->json([
                'message' => 'Failed creating todo'
            ]);
        }
    }

    public function update(Request $request, $id){
        $validatedData = $request->validate([
            'title' => 'required|max:255',
        ]);
        $test = $request->input('title');
        Todo::where('id', '=' , $id) ->update (
            ['title' => $request->input('title'),
            'completed' => $request->input('completed'),
            ]
       );
        try{
            return DB::table('todos')->get()->all();
        }
        catch(Exception $e){
            return response()->json([
                'message' => 'Failed creating todo'
            ]);
        }
    }
}
