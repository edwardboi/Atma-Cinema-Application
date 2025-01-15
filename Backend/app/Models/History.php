<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class History extends Model
{
    use HasFactory;

    public $timestamps = false;
    protected $fillable =[
        'id_tiket'
    ];

    public function tiket() 
    {
        return $this->belongsTo(Tiket::class);
    }
}
