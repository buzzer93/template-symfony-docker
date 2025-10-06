<?php

$finder = (new PhpCsFixer\Finder())
    ->in(__DIR__ . '/src')
    ->in(__DIR__ . '/tests')
    ->exclude(['var', 'vendor'])
    ->name('*.php')
    ->ignoreVCSIgnored(true);

return (new PhpCsFixer\Config())
    ->setRiskyAllowed(true)       // autorise les règles "risky"
    ->setUsingCache(true)         // active le cache (rapide)
    ->setRules([
        '@PSR12' => true,                           // Base : indentation, espaces, import, etc.
        'array_syntax' => ['syntax' => 'short'],    // Favorise les []
        'ordered_imports' => ['sort_algorithm' => 'alpha'], // Trie les use
        'no_unused_imports' => true,                // Supprime les use inutilisés
        'single_quote' => true,                     // Uniformise les quotes
        'trailing_comma_in_multiline' => ['elements' => ['arrays']], // Virgule finale propre
        'phpdoc_align' => ['align' => 'left'],      // Aligne les PHPDoc proprement
        'phpdoc_order' => true,                     // Ordonne les annotations @param/@return
        'phpdoc_summary' => false,                  // Supprime les points forcés à la fin des descriptions
        'no_superfluous_phpdoc_tags' => ['allow_mixed' => true], // Supprime les tags redondants
        'blank_line_before_statement' => [          // Lisibilité entre les blocs
            'statements' => ['return', 'try', 'if', 'for', 'foreach', 'while', 'do', 'switch'],
        ],
    ])
    ->setFinder($finder);
