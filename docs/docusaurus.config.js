// @ts-check

const lightCodeTheme = require("prism-react-renderer/themes/github");
const darkCodeTheme = require("prism-react-renderer/themes/dracula");

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: "マグネタリウム",
  tagline: "宇宙磁石とプラネタリウム",
  favicon: "img/favicon.ico",

  url: "https://rubydog.github.io",
  baseUrl: "/magnetarium/",

  organizationName: "rubydog-jp",
  projectName: "magnetarium",

  onBrokenLinks: "warn",
  onBrokenMarkdownLinks: "warn",

  i18n: {
    defaultLocale: "ja",
    locales: ["ja"],
  },

  presets: [
    [
      "classic",
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          path: "tab_dev",
          routeBasePath: "dev",
          sidebarPath: require.resolve("./tab_dev/sidebars.js"),
        },
        blog: {
          path: "tab_news",
          routeBasePath: "news",
          archiveBasePath: "/news",
          blogTitle: "news",
          showReadingTime: false,
        },
        theme: {
          customCss: require.resolve("./src/css/custom.css"),
        },
      }),
    ],
  ],

  plugins: [
    [
      "@docusaurus/plugin-content-docs",
      {
        id: "tab_join",
        path: "tab_join",
        routeBasePath: "join",
        sidebarPath: require.resolve("./tab_join/sidebars.js"),
      },
    ],
    [
      "@docusaurus/plugin-content-docs",
      {
        id: "tab_support",
        path: "tab_support",
        routeBasePath: "support",
        sidebarPath: require.resolve("./tab_support/sidebars.js"),
      },
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      image: "img/header.png", // OGR?
      navbar: {
        title: "マグネタリウム",
        logo: {
          alt: "Logo",
          src: "img/logo.png",
        },
        items: [
          {
            label: "開発ドキュメント",
            to: "/dev/intro",
            position: "left",
            activeBaseRegex: "/dev/",
          },
          {
            label: "ニュース",
            to: "/news",
            position: "left",
            activeBaseRegex: "/news",
          },
          {
            label: "参加方法",
            to: "/join/overview",
            position: "left",
            activeBaseRegex: "/join/",
          },
          {
            label: "サポート",
            to: "/support/contact",
            position: "left",
            activeBaseRegex: "/support/",
          },
          {
            href: "https://github.com/rubydog-jp/magnetarium",
            label: "GitHub",
            position: "right",
          },
        ],
      },
      footer: {
        style: "dark",
        links: [
          {
            title: "ショートカット",
            items: [
              {
                label: "ホーム画面",
                to: "/",
              },
            ],
          },
          {
            title: "お問い合わせ",
            items: [
              {
                label: "Twitter",
                href: "https://twitter.com/rubydog_jp",
              },
            ],
          },
        ],
        copyright: `Copyright © 2023 Rubydog. Built with Docusaurus.`,
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
    }),
};

module.exports = config;
