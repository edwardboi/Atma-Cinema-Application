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
        Schema::create('jam_tayangs', function (Blueprint $table) {
            $table->id();
            $table->foreignId("id_studio")->constrained("studios")->onDelete("cascade");    
            $table->foreignId("id_jam")->constrained("jams")->onDelete("cascade"); 
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('jam_tayangs');
    }
};
