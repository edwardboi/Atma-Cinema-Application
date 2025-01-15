<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JamTayang extends Model
{
    use HasFactory;

    public $timestamps = false;
    protected $fillable = [
        'id_studio',
        'id_jam',
    ];

    public function studio(){
        return $this->belongsTo(Studio::class, 'id');
    }

    public function jam(){
        return $this->belongsTo(Jam::class, 'id');
    }

    public function pemesanan(){
        return $this->hasMany(Pemesanan::class);
    }
}
