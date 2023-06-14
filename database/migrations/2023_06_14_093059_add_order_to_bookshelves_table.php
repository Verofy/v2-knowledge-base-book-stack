<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddOrderToBookshelvesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('bookshelves', function (Blueprint $table) {
            $table->integer('order')->after('description')->default(0);
        });

        DB::table('bookshelves')->where('id', 4)->update(['order' => 10]);
        DB::table('bookshelves')->where('id', 6)->update(['order' => 20]);
        DB::table('bookshelves')->where('id', 7)->update(['order' => 30]);
        DB::table('bookshelves')->where('id', 8)->update(['order' => 40]);
        DB::table('bookshelves')->where('id', 9)->update(['order' => 50]);

    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('bookshelves', function (Blueprint $table) {
            $table->dropColumn('order');
        });
    }
}
