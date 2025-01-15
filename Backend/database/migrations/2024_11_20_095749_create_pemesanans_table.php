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
        Schema::create('pemesanans', function (Blueprint $table) {
            $table->id();
            $table->foreignId("id_jadwal")->constrained("jadwals")->onDelete("cascade");    
            $table->foreignId("id_film")->constrained("films")->onDelete("cascade");    
            $table->foreignId("id_jamtayang")->constrained("jam_tayangs")->onDelete("cascade");    
            $table->foreignId("id_user")->constrained("users")->onDelete("cascade");    
            // $table->unsignedBigInteger('id_film');
            // $table->unsignedBigInteger('id_studio');
            // $table->foreign('id_film')->references('id_film')->on('films')->onDelete('cascade');
            // $table->foreign('id_studio')->references('id_studio')->on('studios')->onDelete('cascade');
            $table->decimal("harga", 10, 2);
            $table->integer("jumlah_kursi");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pemesanans');
    }
};
