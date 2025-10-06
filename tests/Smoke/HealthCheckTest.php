<?php

use PHPUnit\Framework\TestCase;

final class HealthCheckTest extends TestCase
{
    public function testItWorks(): void
    {
        // Vérifie que la classe Kernel de l'application est autoloadable
        $this->assertTrue(class_exists(App\Kernel::class), 'La classe App\\Kernel doit être autoloadable.');
    }
}
