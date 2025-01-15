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
        Schema::create('films', function (Blueprint $table) {
            $table->id();
            $table->string('nama_film');
            $table->string('genre');
            $table->string('durasi');
            $table->string('sinopsis');
            $table->decimal('rating_film', 3, 1);
            $table->string('rating_usia');
            $table->string('cast');
            $table->string('gambar_film');
            $table->string('status');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('films');
    }
};
