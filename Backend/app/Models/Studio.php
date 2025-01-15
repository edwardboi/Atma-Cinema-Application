<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Studio extends Model
{
    use HasFactory;
    public $timestamps = false;

    protected $fillable = [
        'kapasitas',
        'tipe_studio',
        'jam_tayang',
        'harga'
    ];

    public function pemesanan()
    {
        return $this->hasMany(Pemesanan::class);
    }

    public function jam_tayang()
    {
        return $this->hasMany(JamTayang::class);
    }
}
