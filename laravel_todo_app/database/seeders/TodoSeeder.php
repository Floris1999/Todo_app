<?php

namespace Database\Seeders;


use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;



class TodoSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('todos')->insert([
            'title' => "Maak een assignment voor Nibblr",
            'completed' => true,
            'userId' => 1
        ]);

        DB::table('todos')->insert([
            'title' => "Fietsband plakken",
            'completed' => false,
            'userId' => 1
        ]);

        DB::table('todos')->insert([
            'title' => "Sneeuw vegen",
            'completed' => false,
            'userId' => 1
        ]);
    }
}
