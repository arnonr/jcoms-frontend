import type { MenuItem } from "@/layouts/default-layout/config/types";

const MainMenuConfig: Array<MenuItem> = [
  {
    pages: [
      {
        heading: "dashboard",
        route: "/dashboard",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },
      {
        heading: "เรื่องรอการตรวจสอบ",
        route: "/new-complaint",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },

      {
        heading: "บัญชีรวมเรื่องร้องเรียน/แจ้งเบาะแส",
        route: "/complaint",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },
      {
        heading: "ค้นหาเรื่องร้องเรียน",
        route: "/find-complaint",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },
    ],
  },
  {
    heading: "สถิติ/รายงาน",
    route: "/crafted",
    pages: [
      {
        heading: "จำนวนเรื่องร้องเรียน",
        route: "/report-complaint",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },
      {
        heading: "ประเภทเรื่องร้องเรียน",
        route: "/report-complaint-type",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },
      {
        heading: "ช่องทางการร้องเรียน",
        route: "/report-complaint-channel",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },
      {
        heading: "สายงานที่ถูกร้องเรียน",
        route: "/report",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },
      {
        heading: "หน่วยงานที่ถูกร้องเรียน",
        route: "/report-complaint-organization",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },
      {
        heading: "ข้อกล่าวหาที่ถูกร้องเรียน",
        route: "/report-complaint-topic-type",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },
      {
        heading: "รายงานความพึงพอใจ",
        route: "/report-satisfaction",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },
      {
        heading: "รายงานการเข้าใช้งาน",
        route: "/report-login",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },
      {
        heading: "รายงานการเยี่ยมชมเว็บไซต์",
        route: "/report-visit-website-log",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },
    ],
  },
  {
    heading: "จัดการข้อมูล",
    route: "/crafted",
    pages: [
      //   {
      //     heading: "ทะเบียนหน่วยงาน",
      //     route: "/dashboard",
      //     keenthemesIcon: "element-11",
      //     bootstrapIcon: "bi-app-indicator",
      //   },
      //   {
      //     heading: "ทะเบียนเจ้าหน้าที่",
      //     route: "/dashboard",
      //     keenthemesIcon: "element-11",
      //     bootstrapIcon: "bi-app-indicator",
      //   },
      {
        heading: "ทะเบียนผู้ใช้งาน",
        route: "/user",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },
      {
        heading: "สิทธิระหว่างหน่วยงาน",
        route: "/permission-org",
        keenthemesIcon: "element-11",
        bootstrapIcon: "bi-app-indicator",
      },
      //   {
      //     sectionTitle: "Master Data",
      //     route: "/dashboard",
      //     keenthemesIcon: "element-plus",
      //     bootstrapIcon: "bi-archive",
      //     sub: [
      //       {
      //         heading: "สายงาน",
      //         route: "/dashboard",
      //         keenthemesIcon: "element-11",
      //         bootstrapIcon: "bi-app-indicator",
      //       },
      //       {
      //         heading: "ประเภทเรื่องร้องเรียน/แจ้งเบาะแส",
      //         route: "/dashboard",
      //         keenthemesIcon: "element-11",
      //         bootstrapIcon: "bi-app-indicator",
      //       },
      //       {
      //         heading: "ลักษณะเรื่องร้องเรียน/แจ้งเบาะแส",
      //         route: "/dashboard",
      //         keenthemesIcon: "element-11",
      //         bootstrapIcon: "bi-app-indicator",
      //       },
      //       {
      //         heading: "ข้อกล่าวหา",
      //         route: "/dashboard",
      //         keenthemesIcon: "element-11",
      //         bootstrapIcon: "bi-app-indicator",
      //       },
      //       {
      //         heading: "ช่องทางการร้องเรียน",
      //         route: "/dashboard",
      //         keenthemesIcon: "element-11",
      //         bootstrapIcon: "bi-app-indicator",
      //       },
      //     ],
      //   },
    ],
  },
//   {
//     heading: "คู่มือ",
//     route: "/crafted",
//     pages: [
//       {
//         heading: "คู่มือเจ้าหน้าที่",
//         route: "/staff-manual",
//         keenthemesIcon: "element-11",
//         bootstrapIcon: "bi-app-indicator",
//       },
//       {
//         heading: "คู่มือ ADMIN",
//         route: "/admin-manual",
//         keenthemesIcon: "element-11",
//         bootstrapIcon: "bi-app-indicator",
//       },
//     ],
//   },

  //   {
  //     heading: "craft",
  //     route: "/crafted",
  //     pages: [
  //       {
  //         sectionTitle: "pages",
  //         route: "/pages",
  //         keenthemesIcon: "element-plus",
  //         bootstrapIcon: "bi-archive",
  //         sub: [
  //           {
  //             sectionTitle: "profile",
  //             route: "/profile",
  //             sub: [
  //               {
  //                 heading: "profileOverview",
  //                 route: "/crafted/pages/profile/overview",
  //               },
  //               {
  //                 heading: "projects",
  //                 route: "/crafted/pages/profile/projects",
  //               },
  //               {
  //                 heading: "campaigns",
  //                 route: "/crafted/pages/profile/campaigns",
  //               },
  //               {
  //                 heading: "documents",
  //                 route: "/crafted/pages/profile/documents",
  //               },
  //               {
  //                 heading: "connections",
  //                 route: "/crafted/pages/profile/connections",
  //               },
  //               {
  //                 heading: "activity",
  //                 route: "/crafted/pages/profile/activity",
  //               },
  //             ],
  //           },
  //           {
  //             sectionTitle: "wizards",
  //             route: "/wizard",
  //             sub: [
  //               {
  //                 heading: "horizontal",
  //                 route: "/crafted/pages/wizards/horizontal",
  //               },
  //               {
  //                 heading: "vertical",
  //                 route: "/crafted/pages/wizards/vertical",
  //               },
  //             ],
  //           },
  //         ],
  //       },
  //       {
  //         sectionTitle: "account",
  //         route: "/account",
  //         keenthemesIcon: "profile-circle",
  //         bootstrapIcon: "bi-person",
  //         sub: [
  //           {
  //             heading: "accountOverview",
  //             route: "/crafted/account/overview",
  //           },
  //           {
  //             heading: "settings",
  //             route: "/crafted/account/settings",
  //           },
  //         ],
  //       },
  //       {
  //         sectionTitle: "authentication",
  //         keenthemesIcon: "fingerprint-scanning",
  //         bootstrapIcon: "bi-sticky",
  //         sub: [
  //           {
  //             sectionTitle: "basicFlow",
  //             sub: [
  //               {
  //                 heading: "signIn",
  //                 route: "/sign-in",
  //               },
  //               {
  //                 heading: "signUp",
  //                 route: "/sign-up",
  //               },
  //               {
  //                 heading: "passwordReset",
  //                 route: "/password-reset",
  //               },
  //             ],
  //           },
  //           {
  //             heading: "multiStepSignUp",
  //             route: "/multi-step-sign-up",
  //           },
  //           {
  //             heading: "error404",
  //             route: "/404",
  //           },
  //           {
  //             heading: "error500",
  //             route: "/500",
  //           },
  //         ],
  //       },
  //       {
  //         sectionTitle: "modals",
  //         route: "/modals",
  //         keenthemesIcon: "design",
  //         bootstrapIcon: "bi-shield-check",
  //         sub: [
  //           {
  //             sectionTitle: "general",
  //             route: "/general",
  //             sub: [
  //               {
  //                 heading: "inviteFriends",
  //                 route: "/crafted/modals/general/invite-friends",
  //               },
  //               {
  //                 heading: "viewUsers",
  //                 route: "/crafted/modals/general/view-user",
  //               },
  //               {
  //                 heading: "upgradePlan",
  //                 route: "/crafted/modals/general/upgrade-plan",
  //               },
  //               {
  //                 heading: "shareAndEarn",
  //                 route: "/crafted/modals/general/share-and-earn",
  //               },
  //             ],
  //           },
  //           {
  //             sectionTitle: "forms",
  //             route: "/forms",
  //             sub: [
  //               {
  //                 heading: "newTarget",
  //                 route: "/crafted/modals/forms/new-target",
  //               },
  //               {
  //                 heading: "newCard",
  //                 route: "/crafted/modals/forms/new-card",
  //               },
  //               {
  //                 heading: "newAddress",
  //                 route: "/crafted/modals/forms/new-address",
  //               },
  //               {
  //                 heading: "createAPIKey",
  //                 route: "/crafted/modals/forms/create-api-key",
  //               },
  //             ],
  //           },
  //           {
  //             sectionTitle: "wizards",
  //             route: "/wizards",
  //             sub: [
  //               {
  //                 heading: "twoFactorAuth",
  //                 route: "/crafted/modals/wizards/two-factor-auth",
  //               },
  //               {
  //                 heading: "createApp",
  //                 route: "/crafted/modals/wizards/create-app",
  //               },
  //               {
  //                 heading: "createAccount",
  //                 route: "/crafted/modals/wizards/create-account",
  //               },
  //             ],
  //           },
  //         ],
  //       },
  //       {
  //         sectionTitle: "widgets",
  //         route: "/widgets",
  //         keenthemesIcon: "element-7",
  //         bootstrapIcon: "bi-layers",
  //         sub: [
  //           {
  //             heading: "widgetsLists",
  //             route: "/crafted/widgets/lists",
  //           },
  //           {
  //             heading: "widgetsStatistics",
  //             route: "/crafted/widgets/statistics",
  //           },
  //           {
  //             heading: "widgetsCharts",
  //             route: "/crafted/widgets/charts",
  //           },
  //           {
  //             heading: "widgetsMixed",
  //             route: "/crafted/widgets/mixed",
  //           },
  //           {
  //             heading: "widgetsTables",
  //             route: "/crafted/widgets/tables",
  //           },
  //           {
  //             heading: "widgetsFeeds",
  //             route: "/crafted/widgets/feeds",
  //           },
  //         ],
  //       },
  //     ],
  //   },
  //   {
  //     heading: "apps",
  //     route: "/apps",
  //     pages: [
  //       {
  //         sectionTitle: "customers",
  //         route: "/customers",
  //         keenthemesIcon: "abstract-38",
  //         bootstrapIcon: "bi-printer",
  //         sub: [
  //           {
  //             heading: "gettingStarted",
  //             route: "/apps/customers/getting-started",
  //           },
  //           {
  //             heading: "customersListing",
  //             route: "/apps/customers/customers-listing",
  //           },
  //           {
  //             heading: "customerDetails",
  //             route: "/apps/customers/customer-details",
  //           },
  //         ],
  //       },
  //       {
  //         sectionTitle: "subscriptions",
  //         route: "/subscriptions",
  //         keenthemesIcon: "basket",
  //         bootstrapIcon: "bi-cart",
  //         sub: [
  //           {
  //             heading: "getStarted",
  //             route: "/apps/subscriptions/getting-started",
  //           },
  //           {
  //             heading: "subscriptionList",
  //             route: "/apps/subscriptions/subscription-list",
  //           },
  //           {
  //             heading: "addSubscription",
  //             route: "/apps/subscriptions/add-subscription",
  //           },
  //           {
  //             heading: "viewSubscription",
  //             route: "/apps/subscriptions/view-subscription",
  //           },
  //         ],
  //       },
  //       {
  //         heading: "calendarApp",
  //         route: "/apps/calendar",
  //         keenthemesIcon: "calendar-8",
  //         bootstrapIcon: "bi-calendar3-event",
  //       },
  //       {
  //         sectionTitle: "chat",
  //         route: "/chat",
  //         keenthemesIcon: "message-text-2",
  //         bootstrapIcon: "bi-chat-left",
  //         sub: [
  //           {
  //             heading: "privateChat",
  //             route: "/apps/chat/private-chat",
  //           },
  //           {
  //             heading: "groupChat",
  //             route: "/apps/chat/group-chat",
  //           },
  //           {
  //             heading: "drawerChat",
  //             route: "/apps/chat/drawer-chat",
  //           },
  //         ],
  //       },
  //     ],
  //   },
];

export default MainMenuConfig;
