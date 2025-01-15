<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Jam extends Model
{
    use HasFactory;

    public $timestamps = false;

    protected $fillable = [
        'jam',
    ];

    public function jam_tayang() 
    {
        return $this->hasMany(JamTayang::class);
    }
}
