<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('reviews', function (Blueprint $table) {
            $table->id();
            // $table->unsignedBigInteger('id_film');
            // $table->unsignedBigInteger('id_user');
            $table->foreignId('id_film')->constrained("films")->onDelete('cascade');
            $table->foreignId('id_user')->constrained("users")->onDelete('cascade');
            $table->foreignId('id_tiket')->constrained("tikets")->onDelete('cascade');
            // $table->foreign('id_film')->references('id_film')->on('films')->onDelete('cascade');
            // $table->foreign('id_user')->references('id_user')->on('users')->onDelete('cascade');
            $table->tinyInteger("rating_film", 3, 1);
            $table->string("komentar");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reviews');
    }
};
