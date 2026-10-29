import { getI18nConfig } from "emdash";

/**
 * The default locale from the site's Astro `i18n` config (Japanese when
 * unset), if it names a language this runtime can format.
 */
export function getSiteLocale(): string | undefined {
	// This site is written in Japanese, so fall back to ja when Astro has no i18n config.
	const locale = getI18nConfig()?.defaultLocale ?? "ja";
	try {
		return Intl.DateTimeFormat.supportedLocalesOf(locale)[0];
	} catch {
		// Malformed tags such as "pt_BR" throw instead of matching nothing.
		return undefined;
	}
}

/** Formats a date in the site's locale, or in Japanese without one. */
export function formatDate(date: Date, month: "long" | "short"): string {
	return date.toLocaleDateString(getSiteLocale() ?? "ja-JP", {
		year: "numeric",
		month,
		day: "numeric",
	});
}
