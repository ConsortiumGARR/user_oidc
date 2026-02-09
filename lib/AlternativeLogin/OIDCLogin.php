<?php

namespace OCA\UserOIDC\AlternativeLogin;

use OCP\Authentication\IAlternativeLogin;

class OIDCLogin implements IAlternativeLogin
{
    private $label = '';
    private $link = '';
    private $cssClass = '';
    private static $logins = [];
	private static $customCss = '';

    public function getLabel(): string
    {
        return $this->label;
    }

    public function getLink(): string
    {
        return $this->link;
    }

    public function getClass(): string
    {
        return $this->cssClass;
    }

	public function load(): void
	{
		if (!empty(self::$logins)) {
			list($this->label, $this->link, $this->cssClass) = array_shift(self::$logins);
		}

		\OCP\Util::addStyle('user_oidc', 'oidc_button');

		if (!empty(self::$customCss)) {
			\OCP\Util::addHeader('style', [], self::$customCss);
		}
	}

    public static function addLogin($label, $link, $cssClass = '', $iconUrl = null, $color = null)
    {
        self::$logins[] = [$label, $link, $cssClass];

        if ($iconUrl || $color) {
            $selector = '#alternative-logins a.' . $cssClass;

            if ($iconUrl) {
                self::$customCss .= $selector . '::before { content: ""; background-image: url(' . $iconUrl . '); }' . "\n";
            }
            if ($color) {
                self::$customCss .= $selector . ' { border: 0; color: #fff !important; background-color: ' . $color . ' !important; }' . "\n";
            }
        }
    }
}
